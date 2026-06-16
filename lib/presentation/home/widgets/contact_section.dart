import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/widgets/section_title.dart';
import '../../../data/portfolio_data.dart';

/// Contact section with email CTA and social links.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkBackground]
              : [AppColors.lightCard, AppColors.lightBackground],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              const SectionTitle(title: 'Get In Touch').animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 24),
              Text(
                "I'm currently open to new opportunities. Whether you have a "
                'question, a project idea, or just want to say hi — my inbox '
                'is always open.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  height: 1.7,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse('mailto:${PortfolioData.email}')),
                icon: const Icon(Icons.mail_outline_rounded, size: 20),
                label: const Text('Say Hello'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ).animate().fadeIn(delay: 350.ms, duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 48),
              _SocialLinks(isDark: isDark).animate().fadeIn(delay: 500.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final items = [
      (FontAwesomeIcons.linkedin, 'LinkedIn', PortfolioData.linkedinUrl),
      (FontAwesomeIcons.github, 'GitHub', PortfolioData.githubUrl),
      (FontAwesomeIcons.googlePlay, 'Play Store', PortfolioData.playStoreDevUrl),
      (FontAwesomeIcons.envelope, 'Email', 'mailto:${PortfolioData.email}'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _SocialButton(icon: item.$1, label: item.$2, url: item.$3, isDark: isDark),
            ),
          )
          .toList(),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({required this.icon, required this.label, required this.url, required this.isDark});

  final FaIconData icon;
  final String label;
  final String url;
  final bool isDark;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: _hovered ? AppColors.brandGradient : null,
              color: _hovered ? null : (widget.isDark ? AppColors.darkCard : AppColors.lightCard),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered ? Colors.transparent : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              boxShadow: _hovered
                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: 0)]
                  : null,
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 18,
                color: _hovered
                    ? AppColors.white
                    : (widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
