import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/theme/app_colors.dart';
import '../../../data/portfolio_data.dart';

/// Footer widget for the portfolio site.
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
                child: Text(
                  'TR.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Row(
                children: [
                  _FooterLink(icon: FontAwesomeIcons.linkedin, url: PortfolioData.linkedinUrl, isDark: isDark),
                  const SizedBox(width: 4),
                  _FooterLink(icon: FontAwesomeIcons.github, url: PortfolioData.githubUrl, isDark: isDark),
                  const SizedBox(width: 4),
                  _FooterLink(icon: FontAwesomeIcons.envelope, url: 'mailto:${PortfolioData.email}', isDark: isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${PortfolioData.name} © ${DateTime.now().year}. '
            'Built with Flutter 💜',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.icon, required this.url, required this.isDark});

  final FaIconData icon;
  final String url;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(icon, size: 15, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
      onPressed: () => launchUrl(Uri.parse(url)),
      padding: const EdgeInsets.all(8),
    );
  }
}
