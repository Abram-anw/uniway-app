import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final double blur;
  final double opacity;
  final double radius;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const GlassContainer({
    super.key,
    this.blur = 20,
    this.opacity = 0.11,
    this.radius = 36,
    this.border,
    this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = border ??
        Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1,
        );

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: effectiveBorder,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: opacity + 0.05),
                  Colors.white.withValues(alpha: opacity),
                  AppColors.splashSky.withValues(alpha: 0.025),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.splashNavy.withValues(alpha: 0.42),
                  blurRadius: 34,
                  spreadRadius: 2,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
