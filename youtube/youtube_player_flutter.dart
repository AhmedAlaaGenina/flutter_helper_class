import 'dart:async';
import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

/// Represents the current status of the YPlayer.
enum YPlayerStatus { initial, loading, playing, paused, stopped, error }

class YouTubePlayerController extends ChangeNotifier {
  YouTubePlayerController({
    required this.youtubeUrl,
    this.autoPlay = true,
    this.allowFullScreen = true,
    this.aspectRatio,
    this.allowMuting = true,
    this.placeholder,
    this.loadingWidget,
    this.errorWidget,
    this.materialProgressColors,
    this.cupertinoProgressColors,
  }) {
    initialize();
  }

  // Player configuration properties
  final bool allowFullScreen;
  final bool allowMuting;
  final double? aspectRatio;
  final bool autoPlay;
  final ChewieProgressColors? cupertinoProgressColors;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final ChewieProgressColors? materialProgressColors;
  final Widget? placeholder;
  final String youtubeUrl;

  // Internal properties
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  YPlayerStatus _playerStatus = YPlayerStatus.initial;
  List<VideoQuality> _qualities = [];
  final YoutubeExplode _yt = YoutubeExplode();
  VideoQuality? _currentQuality;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    _yt.close();
    super.dispose();
  }

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  ChewieController? get chewieController => _chewieController;

  List<VideoQuality> get qualities => _qualities;

  /// Gets the current status of the player.
  YPlayerStatus get playerStatus => _playerStatus;

  /// Gets the current playback position.
  Duration get position =>
      _videoPlayerController?.value.position ?? Duration.zero;

  /// Gets the total duration of the video.
  Duration get duration =>
      _videoPlayerController?.value.duration ?? Duration.zero;

  VideoQuality? get currentQuality => _currentQuality;

  /// Initializes the video player.
  Future<void> initialize() async {
    _setPlayerStatus(YPlayerStatus.loading);
    try {
      final video = await _yt.videos.get(youtubeUrl);
      final manifest = await _yt.videos.streamsClient.getManifest(video.id);
      final streams = manifest.muxed;

      _qualities =
          streams.map((s) => VideoQuality(s.qualityLabel, s.url)).toList()
            ..sort((a, b) => int.parse(b.label.replaceAll(RegExp(r'[^\d]'), ''))
                .compareTo(int.parse(a.label.replaceAll(RegExp(r'[^\d]'), ''))))
            ..toSet().toList(); // Remove duplicates

      final highestQualityStream = streams.withHighestBitrate();
      _qualities.add(VideoQuality("Auto", highestQualityStream.url));
      _currentQuality = _qualities.last;
      _videoPlayerController =
          VideoPlayerController.networkUrl(_currentQuality!.url);

      await _videoPlayerController!.initialize();
      _initializeChewieController();
      _videoPlayerController!.addListener(_videoListener);
      _setPlayerStatus(YPlayerStatus.playing);
    } catch (e) {
      _setPlayerStatus(YPlayerStatus.error);
      log("Error initializing video: $e");
    }
    notifyListeners();
  }

  /// Starts or resumes video playback.
  void play() {
    _videoPlayerController?.play();
  }

  /// Pauses video playback.
  void pause() {
    _videoPlayerController?.pause();
  }

  /// Stops video playback and resets to the beginning.
  void stop() {
    _videoPlayerController?.pause();
    _videoPlayerController?.seekTo(Duration.zero);
  }

  /// Seeks to a specific position in the video.
  void seekTo(Duration position) {
    _videoPlayerController?.seekTo(position);
  }

  /// Changes the video quality.
  Future<void> changeQuality(VideoQuality quality) async {
    _setPlayerStatus(YPlayerStatus.loading);
    try {
      final currentPosition = _videoPlayerController!.value.position;
      await _videoPlayerController!.dispose();
      _videoPlayerController = VideoPlayerController.networkUrl(quality.url);
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.seekTo(currentPosition);
      _chewieController?.dispose();
      _initializeChewieController();
      _videoPlayerController!.addListener(_videoListener);
      _setPlayerStatus(YPlayerStatus.playing);
      _currentQuality = quality;
    } catch (e) {
      _setPlayerStatus(YPlayerStatus.error);
      log("Error changing quality of video: $e");
    }
    notifyListeners();
  }

  /// Displays a dialog for selecting video quality.
  void showQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Quality'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _qualities.map((quality) {
                return ListTile(
                  title: Text(quality.label),
                  trailing: quality == _currentQuality
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    changeQuality(quality);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// Video listener to update player status.
  void _videoListener() {
    final playerValue = _videoPlayerController!.value;
    if (playerValue.isPlaying) {
      _setPlayerStatus(YPlayerStatus.playing);
    } else if (playerValue.position >= playerValue.duration) {
      _setPlayerStatus(YPlayerStatus.stopped);
    } else {
      _setPlayerStatus(YPlayerStatus.paused);
    }
  }

  /// Sets the player status and notifies listeners.
  void _setPlayerStatus(YPlayerStatus newStatus) {
    if (_playerStatus != newStatus) {
      _playerStatus = newStatus;
      notifyListeners();
    }
  }

  /// Initializes the Chewie controller.
  void _initializeChewieController() {
    _chewieController = ChewieController(
      placeholder: placeholder,
      videoPlayerController: _videoPlayerController!,
      autoPlay: autoPlay,
      looping: false,
      aspectRatio: aspectRatio ?? (chewieController?.aspectRatio ?? 16 / 9),
      allowFullScreen: allowFullScreen,
      allowMuting: allowMuting,
      materialProgressColors: materialProgressColors ?? ChewieProgressColors(),
      cupertinoProgressColors:
          cupertinoProgressColors ?? ChewieProgressColors(),
      showControls: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      systemOverlaysOnEnterFullScreen: [],
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: () => showQualityDialog(context),
            iconData: Icons.hd,
            title: 'Quality',
          ),
        ];
      },
    );
  }
}

class YouTubePlayer extends StatelessWidget {
  const YouTubePlayer({super.key, required this.controller});

  final YouTubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final aspectRatio = controller.aspectRatio ??
                (controller.chewieController?.aspectRatio ?? 16 / 9);
            final playerWidth = constraints.maxWidth;
            final playerHeight = playerWidth / aspectRatio;

            if (controller.chewieController != null) {
              // Video is ready to play
              return SizedBox(
                width: playerWidth,
                height: playerHeight,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: playerWidth,
                    height: playerHeight,
                    child: Chewie(controller: controller.chewieController!),
                  ),
                ),
              );
            } else if (controller.playerStatus == YPlayerStatus.loading) {
              // Show loading widget
              return _buildLoadingWidget(playerHeight, playerWidth);
            } else if (controller.playerStatus == YPlayerStatus.error) {
              // Show error widget
              return _buildErrorWidget(playerHeight, playerWidth);
            } else {
              // Default empty container
              return Container();
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingWidget(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: controller.loadingWidget ??
            const CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildErrorWidget(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: controller.errorWidget ?? const Text('Error loading video'),
      ),
    );
  }
}

class VideoQuality {
  VideoQuality(this.label, this.url);

  final String label;
  final Uri url;

  @override
  bool operator ==(covariant VideoQuality other) {
    if (identical(this, other)) return true;

    return other.label == label && other.url == url;
  }

  @override
  int get hashCode => label.hashCode ^ url.hashCode;
}
