import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/widgets/gradient_text.dart';
import '../../../data/portfolio_data.dart';

/// Hero/landing section of the portfolio.
class HeroSection extends StatelessWidget {
  const HeroSection({required this.onGetInTouch, required this.onViewProjects, super.key});

  final VoidCallback onGetInTouch;
  final VoidCallback onViewProjects;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: isWide ? 100 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkBackground, const Color(0xFF0F1629), AppColors.darkBackground]
              : [AppColors.lightBackground, const Color(0xFFEEE9FF), AppColors.lightBackground],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              _TagLine(isDark: isDark, isWide: isWide),
              const SizedBox(height: 24),
              _HeroTitle(isWide: isWide),
              const SizedBox(height: 20),
              _Headline(isDark: isDark, isWide: isWide),
              const SizedBox(height: 40),
              _ActionButtons(onGetInTouch: onGetInTouch, onViewProjects: onViewProjects, isWide: isWide),
              const SizedBox(height: 40),
              _SocialLinks(isDark: isDark, isWide: isWide),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagLine extends StatelessWidget {
  const _TagLine({required this.isDark, required this.isWide});

  final bool isDark;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            'Available for new opportunities',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = (isWide ? textTheme.displayMedium : textTheme.headlineLarge)?.copyWith(
      fontWeight: FontWeight.w800,
      height: 1.1,
    );

    return Column(
      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        GradientText(PortfolioData.name, style: titleStyle, gradient: AppColors.brandGradient),
        Text(PortfolioData.tagline, style: titleStyle),
      ],
    ).animate().fadeIn(delay: 250.ms, duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.isDark, required this.isWide});

  final bool isDark;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Text(
        PortfolioData.headline,
        textAlign: isWide ? TextAlign.start : TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          height: 1.7,
          fontSize: 17,
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 700.ms).slideY(begin: 0.2, end: 0);
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onGetInTouch, required this.onViewProjects, required this.isWide});

  final VoidCallback onGetInTouch;
  final VoidCallback onViewProjects;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ElevatedButton.icon(
        onPressed: onGetInTouch,
        icon: const Icon(Icons.mail_outline_rounded, size: 18),
        label: const Text('Get in Touch'),
      ),
      const SizedBox(width: 12, height: 12),
      OutlinedButton.icon(
        onPressed: onViewProjects,
        icon: const Icon(Icons.grid_view_rounded, size: 18),
        label: const Text('View Projects'),
      ),
    ];

    return (isWide
            ? Row(mainAxisSize: MainAxisSize.min, children: buttons)
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: buttons))
        .animate()
        .fadeIn(delay: 550.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks({required this.isDark, required this.isWide});

  final bool isDark;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: isWide ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        _SocialIconButton(
          icon: FontAwesomeIcons.linkedin,
          tooltip: 'LinkedIn',
          url: PortfolioData.linkedinUrl,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: FontAwesomeIcons.github,
          tooltip: 'GitHub',
          url: PortfolioData.githubUrl,
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: FontAwesomeIcons.envelope,
          tooltip: 'Email',
          url: 'mailto:${PortfolioData.email}',
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _SocialIconButton(
          icon: FontAwesomeIcons.googlePlay,
          tooltip: 'Google Play',
          url: PortfolioData.playStoreDevUrl,
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(delay: 700.ms, duration: 600.ms);
  }
}

class _SocialIconButton extends StatefulWidget {
  const _SocialIconButton({required this.icon, required this.tooltip, required this.url, required this.isDark});

  final FaIconData icon;
  final String tooltip;
  final String url;
  final bool isDark;

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : (widget.isDark ? AppColors.darkCard : AppColors.lightCard),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 16,
                color: _hovered
                    ? AppColors.primaryLight
                    : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
