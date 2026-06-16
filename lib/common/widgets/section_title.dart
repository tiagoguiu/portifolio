import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A section title with a gradient underline accent.
class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              subtitle!,
              style: textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
