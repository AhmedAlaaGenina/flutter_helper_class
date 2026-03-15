import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:idara_esign/config/routes/routes.dart';
import 'package:idara_esign/core/services/document_service.dart';
import 'package:idara_esign/features/esign_deep_link_Gate/presentation/cubit/e_sign_deep_link_gate_cubit.dart';
import 'package:idara_esign/generated/l10n.dart';

class ESignDeepLinkGate extends StatefulWidget {
  const ESignDeepLinkGate({
    super.key,
    required this.docId,
    required this.token,
    required this.initialLink,
  });

  final String docId;
  final String token;
  final String initialLink;

  @override
  State<ESignDeepLinkGate> createState() => _ESignDeepLinkGateState();
}

class _ESignDeepLinkGateState extends State<ESignDeepLinkGate> {
  bool _handledGuestBranch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We only need this for the guest branch because it can redirect immediately.
    if (_handledGuestBranch) return;
    _handledGuestBranch = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleGuestBranchIfNeeded();
    });
  }

  void _handleGuestBranchIfNeeded() {
    // final authState = getIt<AuthBloc>().state;
    final authState = context.read<AuthBloc>().state;

    // 1) Not logged in -> go guest access with prefilled link
    if (authState.isUnauthenticated) {
      context.go(
        Routes.guestAccess,
        extra: {'initialLink': widget.initialLink},
      );
      return;
    }
    // 2) Logged in guest
    if (authState.user?.isGuest == true) {
      final lastLink = DeepLinkStore.getLastLink();

      // Same link => resume (dashboard)
      if (lastLink != null && lastLink == widget.initialLink) {
        context.go(Routes.guestDashboard);
        return;
      }

      // New link => restart flow from beginning
      DeepLinkStore.setLastLink(widget.initialLink);
      context.go(
        Routes.guestAccessFromLink,
        extra: {'initialLink': widget.initialLink},
      );
      return;
    }

    // 3) Logged in non-guest -> Build() will render the cubit-driven user branch.
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    if (authState.authStatus == AuthStatus.unknown ||
        authState.currentOperation.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authState.authStatus != AuthStatus.authenticated ||
        authState.user?.isGuest == true) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider<ESignDeepLinkGateCubit>(
      create: (_) =>
          getIt<ESignDeepLinkGateCubit>()
            ..load(documentId: widget.docId, isGuest: false),

      child: BlocConsumer<ESignDeepLinkGateCubit, ESignDeepLinkGateState>(
        listener: (context, state) {
          final doc = state.document;
          if (doc == null) return;
          final userId = authState
              .user!
              .id; // authState.user is guaranteed to be non-null here
          final navService = getIt<DocumentService>();
          final action = navService.getAction(document: doc, userId: userId);
          action.execute(context);
        },
        builder: (context, state) {
          if (state.failure != null) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).couldNotOpenDocument,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.failure?.message ?? '',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<ESignDeepLinkGateCubit>().load(
                                documentId: widget.docId,
                                isGuest: false,
                              );
                            },
                            child: Text(S.of(context).retry),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () => context.go(Routes.userDashboard),
                            child: Text(S.of(context).goHome),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Success is handled in listener (we navigate away).
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
