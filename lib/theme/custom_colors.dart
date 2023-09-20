import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomColors {
  const CustomColors._({
    required this.scheme,
    required this.brightness,
    required this.systemUiOverlayStyle,
  });

  final ColorScheme scheme;
  final Brightness brightness;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  static CustomColors of(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brightness = theme.brightness;
    final systemUiOverlayStyle = SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      statusBarBrightness: brightness,
      statusBarIconBrightness:
          brightness == Brightness.light ? Brightness.dark : Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: scheme.surface,
      systemNavigationBarDividerColor: scheme.surface,
      systemNavigationBarIconBrightness:
          brightness == Brightness.light ? Brightness.dark : Brightness.light,
    );

    return CustomColors._(
      scheme: scheme,
      brightness: brightness,
      systemUiOverlayStyle: systemUiOverlayStyle,
    );
  }
}
