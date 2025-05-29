import 'package:flutter/material.dart';

class NavLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const NavLink({
    super.key,
    required this.text,
    this.onTap,
    this.isActive = false,
    this.activeColor,
    this.inactiveColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style:
              textStyle ??
              TextStyle(
                color:
                    isActive
                        ? (activeColor ?? theme.primaryColor)
                        : (inactiveColor ?? theme.textTheme.bodyMedium?.color),
                fontSize: fontSize ?? 16,
                fontWeight:
                    isActive
                        ? (fontWeight ?? FontWeight.w600)
                        : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
