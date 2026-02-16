import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_news/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _letterSpacing;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ), // Slightly slower for elegance
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Premium "Cinematic" Text Effect
    _letterSpacing = Tween<double>(begin: 20.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutExpo),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/feed');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Gradient background adds instant depth
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: isDark
                ? [const Color(0xFF1A1A1A), Colors.black]
                : [Colors.white, const Color(0xFFF2F2F7)],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Premium Logo Container
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.pulseRed,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.pulseRed.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              // Adding a "core" glow
                              color: AppColors.pulseRed.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.monitor_heart_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Animated Typography
                      Text(
                        'PULSE',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              letterSpacing: _letterSpacing.value,
                              fontWeight: FontWeight.w900,
                              // Use a secondary color for subtle contrast
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                      ),

                      const SizedBox(height: 8),

                      // Modern separator line
                      Container(
                        width: 40,
                        height: 1,
                        color: AppColors.pulseRed.withValues(alpha: 0.5),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'GLOBAL NEWS ENGINE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.pulseRed,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
