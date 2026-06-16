import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/widgets/hover_card.dart';
import '../../../common/widgets/section_title.dart';
import '../../../data/portfolio_data.dart';
import '../../../domain/entity/project_entity.dart';

/// Featured projects section displayed in a responsive grid.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
                title: 'Featured Projects',
                subtitle: 'Things I\'ve built and shipped',
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 700 ? 2 : 1;
                  final projects = PortfolioData.projects
                      .where((project) => project.isFeatured)
                      .toList(growable: false);
                  return _ProjectsGrid(projects: projects, columns: columns, isDark: isDark);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects, required this.columns, required this.isDark});

  final List<ProjectEntity> projects;
  final int columns;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (columns == 1) {
      return Column(
        children: projects
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _ProjectCard(project: e.value, index: e.key, isDark: isDark),
              ),
            )
            .toList(),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < projects.length; i += 2) {
      final left = projects[i];
      final right = i + 1 < projects.length ? projects[i + 1] : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ProjectCard(project: left, index: i, isDark: isDark),
              ),
              if (right != null) ...[
                const SizedBox(width: 20),
                Expanded(
                  child: _ProjectCard(project: right, index: i + 1, isDark: isDark),
                ),
              ] else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.index, required this.isDark});

  final ProjectEntity project;
  final int index;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return HoverCard(
      onTap: project.playStoreUrl != null
          ? () => launchUrl(Uri.parse(project.playStoreUrl!))
          : project.websiteUrl != null
          ? () => launchUrl(Uri.parse(project.websiteUrl!))
          : project.githubUrl != null
          ? () => launchUrl(Uri.parse(project.githubUrl!))
          : null,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ProjectIcon(project: project, isDark: isDark),
                const Spacer(),
                _ProjectLinks(project: project, isDark: isDark),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: textTheme.titleLarge?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (project.statusTag != null) ...[
                  const SizedBox(width: 8),
                  _ProjectStatusTag(label: project.statusTag!),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              style: textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: project.technologies.map((tech) => _TechChip(tech: tech, isDark: isDark)).toList(),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}

class _ProjectIcon extends StatelessWidget {
  const _ProjectIcon({required this.project, required this.isDark});

  final ProjectEntity project;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(12)),
      child: Center(child: FaIcon(_iconForProject(project.id), size: 22, color: AppColors.white)),
    );
  }

  FaIconData _iconForProject(String id) => switch (id) {
    'dne' => FontAwesomeIcons.idCard,
    'facilalagoas' => FontAwesomeIcons.busSimple,
    'levobra' => FontAwesomeIcons.buildingColumns,
    'chuzz' => FontAwesomeIcons.utensils,
    'zira' => FontAwesomeIcons.locationDot,
    'imedy' => FontAwesomeIcons.video,
    _ => FontAwesomeIcons.mobileScreen,
  };
}

class _ProjectLinks extends StatelessWidget {
  const _ProjectLinks({required this.project, required this.isDark});

  final ProjectEntity project;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (project.playStoreUrl != null)
          _LinkIcon(
            icon: FontAwesomeIcons.googlePlay,
            url: project.playStoreUrl!,
            tooltip: 'Google Play',
            isDark: isDark,
          ),
        if (project.githubUrl != null)
          _LinkIcon(icon: FontAwesomeIcons.github, url: project.githubUrl!, tooltip: 'GitHub', isDark: isDark),
        if (project.websiteUrl != null)
          _LinkIcon(
            icon: FontAwesomeIcons.arrowUpRightFromSquare,
            url: project.websiteUrl!,
            tooltip: 'Website',
            isDark: isDark,
          ),
      ],
    );
  }
}

class _LinkIcon extends StatelessWidget {
  const _LinkIcon({required this.icon, required this.url, required this.tooltip, required this.isDark});

  final FaIconData icon;
  final String url;
  final String tooltip;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: FaIcon(icon, size: 15, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        onPressed: () => launchUrl(Uri.parse(url)),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  const _TechChip({required this.tech, required this.isDark});

  final String tech;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        tech,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ProjectStatusTag extends StatelessWidget {
  const _ProjectStatusTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.warning, fontWeight: FontWeight.w700),
      ),
    );
  }
}
