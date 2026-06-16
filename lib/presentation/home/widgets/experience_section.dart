import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/widgets/section_title.dart';
import '../../../data/portfolio_data.dart';
import '../../../domain/entity/experience_entity.dart';

/// Work experience section with a timeline layout.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 24, vertical: 80),
      color: isDark ? AppColors.darkSurface.withValues(alpha: 0.5) : AppColors.lightCard.withValues(alpha: 0.5),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                title: 'Work Experience',
                subtitle: 'Where I\'ve been building things',
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
              const SizedBox(height: 48),
              ...PortfolioData.experiences.asMap().entries.map(
                (entry) => _ExperienceCard(
                  experience: entry.value,
                  index: entry.key,
                  isDark: isDark,
                  isLast: entry.key == PortfolioData.experiences.length - 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience, required this.index, required this.isDark, required this.isLast});

  final ExperienceEntity experience;
  final int index;
  final bool isDark;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimelineIndicator(isCurrent: experience.isCurrent, isLast: isLast, isDark: isDark),
          const SizedBox(width: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                experience.role,
                                style: textTheme.titleLarge?.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                experience.company,
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: experience.isCurrent
                                    ? AppColors.success.withValues(alpha: 0.15)
                                    : AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: experience.isCurrent
                                      ? AppColors.success.withValues(alpha: 0.4)
                                      : AppColors.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                experience.period,
                                style: textTheme.labelSmall?.copyWith(
                                  color: experience.isCurrent ? AppColors.success : AppColors.primaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...experience.highlights.map(
                      (highlight) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  gradient: AppColors.brandGradient,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                highlight,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 500.ms).slideX(begin: -0.05, end: 0);
  }
}

class _TimelineIndicator extends StatelessWidget {
  const _TimelineIndicator({required this.isCurrent, required this.isLast, required this.isDark});

  final bool isCurrent;
  final bool isLast;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isCurrent ? AppColors.brandGradient : null,
              color: isCurrent ? null : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              border: isCurrent
                  ? null
                  : Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, width: 2),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withValues(alpha: 0.4), AppColors.darkBorder.withValues(alpha: 0.2)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
