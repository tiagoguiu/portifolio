import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/widgets/section_title.dart';
import '../../../data/portfolio_data.dart';

/// About section — bio and skills.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 900;

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
                title: 'About Me',
                subtitle: 'Passionate about mobile excellence',
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
              const SizedBox(height: 48),
              isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _BioText(isDark: isDark)),
                        const SizedBox(width: 60),
                        Expanded(flex: 2, child: _SkillsGrid(isDark: isDark)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BioText(isDark: isDark),
                        const SizedBox(height: 40),
                        _SkillsGrid(isDark: isDark),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BioText extends StatelessWidget {
  const _BioText({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PortfolioData.about,
          style: textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            height: 1.8,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        _StatRow(isDark: isDark),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.05);
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(value: '5+', label: 'Years Exp.', isDark: isDark),
        const SizedBox(width: 32),
        _Stat(value: '1M+', label: 'Downloads', isDark: isDark),
        const SizedBox(width: 32),
        _Stat(value: '3+', label: 'Countries', isDark: isDark),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.isDark});

  final String value;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
          child: Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  const _SkillsGrid({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PortfolioData.skillGroups
          .map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _SkillGroup(group: group, isDark: isDark),
            ),
          )
          .toList(),
    ).animate().fadeIn(delay: 350.ms, duration: 600.ms).slideX(begin: 0.05);
  }
}

class _SkillGroup extends StatelessWidget {
  const _SkillGroup({required this.group, required this.isDark});

  final dynamic group;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.category as String,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.accentLight,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: (group.skills as List<String>).map((skill) => _SkillChip(skill: skill, isDark: isDark)).toList(),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.skill, required this.isDark});

  final String skill;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Text(
        skill,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
