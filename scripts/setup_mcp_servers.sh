#!/bin/bash
# ============================================================
# MCP Server Setup Script for Antigravity (Gemini Code Assist)
# ============================================================
# This script installs and configures all MCP servers on a new
# macOS device. Run it once after setting up a new machine.
#
# Usage:
#   chmod +x scripts/setup_mcp_servers.sh
#   ./scripts/setup_mcp_servers.sh
#
# Prerequisites: macOS with Homebrew, Node.js, and Flutter/Dart
# ============================================================
# Created the setup script at scripts/setup_mcp_servers.sh.

# How to use on a new device:
# 1. Copy the script to the new machine (it's in your project repo, so it'll come with a git clone)

# 2. Update the tokens at the top of the script if needed (GitHub PAT, Figma token, Stitch API key)

# 3. Run it:

# bash
# cd /path/to/idara-esign-app
# chmod +x scripts/setup_mcp_servers.sh
# ./scripts/setup_mcp_servers.sh
# 4. Install Stitch skills manually (the interactive CLI can't be automated):

# bash
# npx skills add google-labs-code/stitch-skills --skill design-md --global
# npx skills add google-labs-code/stitch-skills --skill stitch-loop --global
# # ... etc for each skill
# 5. Restart your IDE — all 11 MCP servers will be ready!

# ⚠️ Security note: The script contains your API tokens. Don't commit it to a public repo. Consider adding scripts/setup_mcp_servers.sh to .gitignore.
# ============================================================

set -e

# ── Colors ──
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}ℹ️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠️  $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; exit 1; }

# ── Configuration (UPDATE THESE FOR YOUR MACHINE) ──
GITHUB_PAT="<YOUR_GITHUB_PAT>"
FIGMA_API_TOKEN="<YOUR_FIGMA_API_TOKEN>"
STITCH_API_KEY="<YOUR_STITCH_API_KEY>"

MCP_DIR="$HOME/.mcp-servers"
CONFIG_DIR="$HOME/.gemini/antigravity"
CONFIG_FILE="$CONFIG_DIR/mcp_config.json"

# ── Step 0: Detect Dart path ──
info "Detecting Dart SDK path..."
if command -v dart &>/dev/null; then
  DART_PATH=$(command -v dart)
elif [ -f "$HOME/fvm/versions/stable/bin/dart" ]; then
  DART_PATH="$HOME/fvm/versions/stable/bin/dart"
elif [ -f "$HOME/.fvm/default/bin/dart" ]; then
  DART_PATH="$HOME/.fvm/default/bin/dart"
else
  error "Dart SDK not found. Install Flutter/Dart first."
fi
success "Dart found at: $DART_PATH"

# ── Step 1: Install system dependencies ──
info "Checking system dependencies..."

if ! command -v brew &>/dev/null; then
  error "Homebrew not found. Install from https://brew.sh"
fi

if ! command -v node &>/dev/null; then
  info "Installing Node.js..."
  brew install node
fi
success "Node.js ready"

if ! command -v uvx &>/dev/null; then
  info "Installing uv (Python package runner)..."
  brew install uv
fi
UVX_PATH=$(which uvx)
success "uv ready at: $UVX_PATH"

# ── Step 2: Create MCP servers directory ──
mkdir -p "$MCP_DIR"
mkdir -p "$CONFIG_DIR"

# ── Step 3: Clone and build MCP servers ──

# 3a. iOS Simulator MCP
if [ ! -d "$MCP_DIR/mcp-server-simulator-ios-idb" ]; then
  info "Cloning iOS Simulator MCP..."
  git clone https://github.com/InditexTech/mcp-server-simulator-ios-idb.git "$MCP_DIR/mcp-server-simulator-ios-idb"
  cd "$MCP_DIR/mcp-server-simulator-ios-idb"
  python3 -m venv venv
  source venv/bin/activate
  npm install --ignore-scripts
  npm run build
  bash ./scripts/install_dependencies.sh 2>/dev/null || true
  deactivate 2>/dev/null || true
  success "iOS Simulator MCP installed"
else
  success "iOS Simulator MCP already installed"
fi

# 3b. Flutter MCP Server (thecentinol)
if [ ! -d "$MCP_DIR/flutter_mcp_server" ]; then
  info "Cloning Flutter MCP Server (thecentinol)..."
  git clone https://github.com/thecentinol/flutter_mcp_server.git "$MCP_DIR/flutter_mcp_server"
  cd "$MCP_DIR/flutter_mcp_server"
  "$DART_PATH" pub get
  success "Flutter MCP Server installed"
else
  success "Flutter MCP Server already installed"
fi

# 3c. Flutter Inspector MCP (Arenukvern)
if [ ! -d "$MCP_DIR/mcp_flutter" ]; then
  info "Cloning Flutter Inspector MCP (Arenukvern)..."
  git clone https://github.com/Arenukvern/mcp_flutter.git "$MCP_DIR/mcp_flutter"
  cd "$MCP_DIR/mcp_flutter"
  make install
  success "Flutter Inspector MCP installed"
else
  success "Flutter Inspector MCP already installed"
fi

# ── Step 4: Install Stitch Skills ──
info "Installing Stitch Skills..."
SKILLS=("design-md" "react:components" "stitch-loop" "enhance-prompt" "remotion" "shadcn-ui")
for skill in "${SKILLS[@]}"; do
  info "  → Skill: $skill (run manually: npx skills add google-labs-code/stitch-skills --skill $skill --global)"
done
warn "Skills require interactive install. Run the commands above manually."

# ── Step 5: Generate mcp_config.json ──
info "Generating MCP config..."

cat > "$CONFIG_FILE" << EOF
{
  "mcpServers": {
    "dart-mcp-server": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "$DART_PATH",
      "args": ["mcp-server"],
      "env": {}
    },
    "firebase-mcp-server": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "npx",
      "args": ["-y", "firebase-tools@latest", "mcp"],
      "env": {}
    },
    "github-mcp-server": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_PAT"
      }
    },
    "stitch": {
      "serverUrl": "https://stitch.googleapis.com/mcp",
      "headers": {
        "X-Goog-Api-Key": "$STITCH_API_KEY"
      }
    },
    "ios-simulator": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "node",
      "args": ["$MCP_DIR/mcp-server-simulator-ios-idb/dist/index.js"],
      "env": {}
    },
    "fetch": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "$UVX_PATH",
      "args": ["mcp-server-fetch"],
      "env": {}
    },
    "git": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "$UVX_PATH",
      "args": ["mcp-server-git"],
      "env": {}
    },
    "flutter-mcp": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "$UVX_PATH",
      "args": ["--from", "git+https://github.com/adamsmaka/flutter-mcp.git", "flutter-mcp"],
      "env": {}
    },
    "flutter_mcp_server": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "$DART_PATH",
      "args": ["run", "$MCP_DIR/flutter_mcp_server/bin/flutter_mcp_server.dart"],
      "env": {}
    },
    "flutter-inspector": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "$MCP_DIR/mcp_flutter/mcp_server_dart/build/flutter_inspector_mcp",
      "args": ["--dart-vm-host=localhost", "--dart-vm-port=8181", "--no-resources", "--images"],
      "env": {}
    },
    "figma": {
      "\$typeName": "exa.cascade_plugins_pb.CascadePluginCommandTemplate",
      "command": "npx",
      "args": ["-y", "figma-mcp"],
      "env": {
        "FIGMA_API_TOKEN": "$FIGMA_API_TOKEN"
      }
    }
  }
}
EOF

success "Config written to: $CONFIG_FILE"

# ── Done ──
echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  🎉 MCP Setup Complete!               ${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
echo "11 MCP servers configured:"
echo "  1. dart-mcp-server     (Dart/Flutter dev tools)"
echo "  2. firebase-mcp-server (Firebase management)"
echo "  3. github-mcp-server   (GitHub integration)"
echo "  4. stitch              (UI design generation)"
echo "  5. ios-simulator       (iOS simulator control)"
echo "  6. fetch               (Web content fetching)"
echo "  7. git                 (Git operations)"
echo "  8. flutter-mcp         (Flutter/Dart docs)"
echo "  9. flutter_mcp_server  (Flutter code generation)"
echo " 10. flutter-inspector   (Live app inspection)"
echo " 11. figma               (Figma design integration)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Install Stitch skills manually (see commands above)"
echo "  2. Restart your IDE"
echo "  3. Start chatting with AI!"
