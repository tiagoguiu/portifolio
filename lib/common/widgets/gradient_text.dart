import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Renders text with a gradient fill using a shader mask.
class GradientText extends StatelessWidget {
  const GradientText(this.text, {required this.style, this.gradient = AppColors.brandGradient, super.key});

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }
}
