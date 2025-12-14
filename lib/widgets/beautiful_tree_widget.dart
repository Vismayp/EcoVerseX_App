import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../config/theme.dart';

class BeautifulTreeWidget extends StatefulWidget {
  final int streakCount;
  final double progress; // 0.0 to 1.0

  const BeautifulTreeWidget({
    super.key,
    required this.streakCount,
    this.progress = 0.5,
  });

  @override
  State<BeautifulTreeWidget> createState() => _BeautifulTreeWidgetState();
}

class _BeautifulTreeWidgetState extends State<BeautifulTreeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE0F7FA), // Light Cyan
                AppColors.background,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Sun
              Positioned(
                top: 20,
                right: 30,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              // Clouds
              Positioned(
                top: 30,
                left: 40,
                child: Opacity(
                  opacity: 0.5,
                  child: CustomPaint(
                    size: const Size(60, 20),
                    painter: CloudPainter(),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 80,
                child: Opacity(
                  opacity: 0.4,
                  child: CustomPaint(
                    size: const Size(50, 18),
                    painter: CloudPainter(),
                  ),
                ),
              ),
              // Tree
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Tree Crown
                    CustomPaint(
                      size:
                          Size(140 * _animation.value, 120 * _animation.value),
                      painter: TreeCrownPainter(progress: widget.progress),
                    ),
                    // Tree Trunk
                    Container(
                      width: 25,
                      height: 50 * _animation.value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6D4C41),
                            const Color(0xFF8D6E63),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Info
                    Text(
                      'Your Tree is Growing!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade700,
                            Colors.deepOrange.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.streakCount} Day Streak',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TreeCrownPainter extends CustomPainter {
  final double progress;

  TreeCrownPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw multiple overlapping circles to create a lush crown
    final centers = [
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.7),
    ];

    final greenShades = [
      const Color(0xFF1B5E20),
      const Color(0xFF2E7D32),
      const Color(0xFF388E3C),
      const Color(0xFF43A047),
      const Color(0xFF4CAF50),
    ];

    // Add leaves with varying sizes and shades
    for (int i = 0; i < centers.length; i++) {
      paint.shader = RadialGradient(
        colors: [
          greenShades[i % greenShades.length],
          greenShades[(i + 2) % greenShades.length].withOpacity(0.8),
        ],
        center: Alignment.topLeft,
        radius: 0.8,
      ).createShader(
        Rect.fromCircle(
          center: centers[i],
          radius: size.width * 0.18 * (0.8 + progress * 0.4),
        ),
      );

      canvas.drawCircle(
        centers[i],
        size.width * 0.18 * (0.8 + progress * 0.4),
        paint,
      );

      // Add highlight
      paint.shader = null;
      paint.color = Colors.white.withOpacity(0.2);
      canvas.drawCircle(
        Offset(centers[i].dx - 8, centers[i].dy - 8),
        size.width * 0.08,
        paint,
      );
    }

    // Add some fruits/flowers
    paint.shader = null;
    final fruitPositions = [
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.65),
    ];

    for (var pos in fruitPositions) {
      // Red fruits
      paint.color = Colors.red.shade400;
      canvas.drawCircle(pos, 6, paint);
      paint.color = Colors.red.shade300;
      canvas.drawCircle(Offset(pos.dx - 2, pos.dy - 2), 3, paint);
    }
  }

  @override
  bool shouldRepaint(TreeCrownPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw three overlapping circles to create a cloud
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * 0.5), size.height * 0.5, paint);
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.4), size.height * 0.6, paint);
    canvas.drawCircle(
        Offset(size.width * 0.75, size.height * 0.5), size.height * 0.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
