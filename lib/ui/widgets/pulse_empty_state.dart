import 'package:flutter/material.dart';
import 'package:pulse_news/core/theme/app_colors.dart';

class PulseEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const PulseEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    // Premium Muted Tones
    final tertiaryColor = isDark
        ? AppColors.darkTextTertiary.withValues(alpha: 0.3)
        : AppColors.lightTextTertiary.withValues(alpha: 0.4);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Elegant Gradient Icon
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [tertiaryColor, tertiaryColor.withValues(alpha: 0.1)],
              ).createShader(bounds),
              child: Icon(icon, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),

            //Title
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Text(
                subtitle!,
                style: textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (onAction != null) ...[
              const SizedBox(height: 32),
              // Button
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pulseRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: AppColors.pulseRed.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  (actionLabel ?? 'Try Again').toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
