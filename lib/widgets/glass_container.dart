import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable Glassmorphism Container with blur, translucent fill, borders, and soft shadows.
class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double blurSigma;
  final VoidCallback? onTap;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;

  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.blurSigma = 16.0,
    this.onTap,
    this.alignment,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(24.0);
    final effectiveBorder = border ??
        Border.all(
          color: AppColors.glassBorder,
          width: 1.0,
        );
    final effectiveFill = color ?? AppColors.glassCard;
    final effectiveShadow = boxShadow ??
        [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ];

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: effectiveFill,
        borderRadius: effectiveRadius,
        border: effectiveBorder,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius is BorderRadius ? effectiveRadius : BorderRadius.circular(24.0),
        child: InkWell(
          borderRadius: effectiveRadius is BorderRadius ? effectiveRadius : BorderRadius.circular(24.0),
          onTap: onTap,
          splashColor: AppColors.iceBlue.withValues(alpha: 0.2),
          highlightColor: AppColors.warmSand.withValues(alpha: 0.3),
          child: content,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        boxShadow: effectiveShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: content,
        ),
      ),
    );
  }
}
