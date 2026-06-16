import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/theme/app_colors.dart';
import '../state/theme_notifier.dart';

/// Responsive navigation bar for the portfolio.
class NavBar extends ConsumerStatefulWidget {
  const NavBar({required this.onScrollToSection, super.key});

  final void Function(String section) onScrollToSection;

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  bool _mobileMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 768;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.92),
        border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 48 : 20, vertical: 8),
            child: Row(
              children: [
                _Logo(isDark: isDark),
                const Spacer(),
                if (isWide) ...[
                  _NavLinks(onScrollToSection: widget.onScrollToSection, isDark: isDark),
                  const SizedBox(width: 24),
                ],
                _ThemeToggle(isDark: isDark),
                if (!isWide) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: FaIcon(
                      _mobileMenuOpen ? FontAwesomeIcons.xmark : FontAwesomeIcons.bars,
                      size: 18,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    onPressed: () => setState(() => _mobileMenuOpen = !_mobileMenuOpen),
                  ),
                ],
              ],
            ),
          ),
          if (!isWide && _mobileMenuOpen)
            _MobileMenu(
              onScrollToSection: (section) {
                setState(() => _mobileMenuOpen = false);
                widget.onScrollToSection(section);
              },
              isDark: isDark,
            ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
      child: Text(
        'TR.',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1),
      ),
    );
  }
}

class _NavLinks extends StatelessWidget {
  const _NavLinks({required this.onScrollToSection, required this.isDark});

  final void Function(String) onScrollToSection;
  final bool isDark;

  static const _items = [
    ('About', 'about'),
    ('Experience', 'experience'),
    ('Projects', 'projects'),
    ('Education', 'education'),
    ('Contact', 'contact'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _NavLinkButton(label: item.$1, onTap: () => onScrollToSection(item.$2), isDark: isDark),
            ),
          )
          .toList(),
    );
  }
}

class _NavLinkButton extends StatefulWidget {
  const _NavLinkButton({required this.label, required this.onTap, required this.isDark});

  final String label;
  final VoidCallback onTap;
  final bool isDark;

  @override
  State<_NavLinkButton> createState() => _NavLinkButtonState();
}

class _NavLinkButtonState extends State<_NavLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _hovered ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: _hovered
                  ? AppColors.primaryLight
                  : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      icon: FaIcon(
        isDark ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
        size: 16,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.onScrollToSection, required this.isDark});

  final void Function(String) onScrollToSection;
  final bool isDark;

  static const _items = [
    ('About', 'about'),
    ('Experience', 'experience'),
    ('Projects', 'projects'),
    ('Education', 'education'),
    ('Contact', 'contact'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _items
            .map(
              (item) => ListTile(
                title: Text(
                  item.$1,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () => onScrollToSection(item.$2),
              ),
            )
            .toList(),
      ),
    );
  }
}
