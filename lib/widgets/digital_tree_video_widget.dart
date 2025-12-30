import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../config/theme.dart';
import 'neo/neo_card.dart';

class DigitalTreeVideoWidget extends StatefulWidget {
  final int streakCount;

  const DigitalTreeVideoWidget({
    super.key,
    required this.streakCount,
  });

  @override
  State<DigitalTreeVideoWidget> createState() => _DigitalTreeVideoWidgetState();
}

class _DigitalTreeVideoWidgetState extends State<DigitalTreeVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  Timer? _loopTimer;
  late Duration _targetPosition;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller =
        VideoPlayerController.asset('assets/animations/tree_growth.mp4');

    try {
      await _controller.initialize();
      await _controller.setVolume(0.0); // Mute the video

      // Calculate progress based on streak count and days in month
      final now = DateTime.now();
      final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

      // Use streakCount as the progress indicator for the month
      // Clamp to ensure it doesn't exceed 1.0
      final double progress =
          (widget.streakCount / daysInMonth).clamp(0.01, 1.0);

      _targetPosition = _controller.value.duration * progress;

      setState(() {
        _isInitialized = true;
      });

      _startGrowthAnimation();
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _startGrowthAnimation() async {
    if (!mounted || !_isInitialized) return;

    await _controller.seekTo(Duration.zero);
    await _controller.play();

    _controller.addListener(_checkPosition);
  }

  void _checkPosition() {
    if (_controller.value.position >= _targetPosition) {
      _controller.removeListener(_checkPosition);
      _controller.pause();

      _loopTimer?.cancel();
      _loopTimer = Timer(const Duration(seconds: 7), () {
        _startGrowthAnimation();
      });
    }
  }

  String _getStreakTag() {
    if (widget.streakCount <= 3) return 'Sprout';
    if (widget.streakCount <= 7) return 'Seedling';
    if (widget.streakCount <= 14) return 'Sapling';
    if (widget.streakCount <= 21) return 'Young Tree';
    if (widget.streakCount <= 29) return 'Mature Tree';
    return 'Ancient Oak';
  }

  @override
  void dispose() {
    _loopTimer?.cancel();
    _controller.removeListener(_checkPosition);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      borderRadius: BorderRadius.circular(28),
      padding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Stack(
          children: [
            // Video Layer
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: _isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.cardDark,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            ),

            // Gradient Overlay (Top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 140,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Gradient Overlay (Bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Streak Badge
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.streakCount} Day Streak',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStreakTag(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info Text
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Digital Tree',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Growing with your impact',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
