import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/widgets/section_title.dart';
import '../../../data/portfolio_data.dart';
import '../../../domain/entity/education_entity.dart';

/// Education section displaying degrees and institutions.
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Education',
                subtitle: 'Academic foundation & ongoing learning',
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
              const SizedBox(height: 48),
              isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: PortfolioData.education
                          .asMap()
                          .entries
                          .map(
                            (e) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: e.key < PortfolioData.education.length - 1 ? 24 : 0),
                                child: _EducationCard(edu: e.value, index: e.key, isDark: isDark),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Column(
                      children: PortfolioData.education
                          .asMap()
                          .entries
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _EducationCard(edu: e.value, index: e.key, isDark: isDark),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.edu, required this.index, required this.isDark});

  final EducationEntity edu;
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: FaIcon(FontAwesomeIcons.graduationCap, size: 18, color: AppColors.white)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (edu.isInProgress)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              'In Progress',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        else
                          Text(
                            edu.period,
                            style: textTheme.labelSmall?.copyWith(
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            edu.degree,
            style: textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _InstitutionLink(edu: edu, isDark: isDark),
          const SizedBox(height: 16),
          Text(
            edu.description,
            style: textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.65,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 150).ms, duration: 600.ms).slideY(begin: 0.1, end: 0);
  }
}

class _InstitutionLink extends StatefulWidget {
  const _InstitutionLink({required this.edu, required this.isDark});

  final EducationEntity edu;
  final bool isDark;

  @override
  State<_InstitutionLink> createState() => _InstitutionLinkState();
}

class _InstitutionLinkState extends State<_InstitutionLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final canLaunch = widget.edu.institutionUrl != null;

    return MouseRegion(
      onEnter: canLaunch ? (_) => setState(() => _hovered = true) : null,
      onExit: canLaunch ? (_) => setState(() => _hovered = false) : null,
      cursor: canLaunch ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: canLaunch ? () => launchUrl(Uri.parse(widget.edu.institutionUrl!)) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.buildingColumns,
              size: 13,
              color: _hovered ? AppColors.primaryLight : AppColors.accent,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                widget.edu.institution,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _hovered ? AppColors.primaryLight : AppColors.accent,
                  decoration: _hovered ? TextDecoration.underline : null,
                  decorationColor: AppColors.primaryLight,
                ),
              ),
            ),
            if (canLaunch) ...[
              const SizedBox(width: 4),
              FaIcon(
                FontAwesomeIcons.arrowUpRightFromSquare,
                size: 10,
                color: _hovered ? AppColors.primaryLight : AppColors.accent.withValues(alpha: 0.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
