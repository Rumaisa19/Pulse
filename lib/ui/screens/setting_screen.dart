import 'package:flutter/material.dart';
import 'package:pulse_news/core/theme/app_colors.dart';
import 'package:pulse_news/logic/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController(context);
    final isDark = controller.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'SETTINGS',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 22,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        children: [
          _Section(
            title: 'Appearance',
            children: [
              _Tile(
                icon: isDark
                    ? Icons.dark_mode_rounded
                    : Icons.light_mode_rounded,
                title: 'Dark Mode',
                trailing: Switch.adaptive(
                  value: isDark,
                  activeThumbColor: AppColors.pulseRed,
                  onChanged: (_) => controller.toggleTheme(),
                ),
              ),
            ],
          ),
          _Section(
            title: 'About',
            children: [
              _Tile(
                icon: Icons.newspaper_rounded,
                title: 'Pulse News',
                subtitle: 'Version ${controller.appVersion}',
              ),
              const _Tile(
                icon: Icons.code_rounded,
                title: 'Built with Flutter',
              ),
              _Tile(
                icon: Icons.api_rounded,
                title: 'Data Source',
                subtitle: controller.dataSource,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Internal Widgets remain private to the UI file
class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const _Tile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.pulseRed),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: subtitle != null
          ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall)
          : null,
      trailing: trailing,
    );
  }
}
