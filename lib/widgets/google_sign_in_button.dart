import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:globo_quest/constants/assets.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
          EdgeInsets.fromLTRB(4, 4, 16, 4),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }

          final color = Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF4285F4);

          return color;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          final color = Theme.of(context).brightness == Brightness.light
              ? const Color(0xFF444444)
              : const Color(0xFFFFFFFF);

          if (states.contains(MaterialState.disabled)) {
            return color.withOpacity(0.7);
          }

          return color;
        }),
        overlayColor: MaterialStatePropertyAll(
          Theme.of(context).brightness == Brightness.light
              ? const Color(0x8ADBDBDB)
              : const Color(0x20FFFFFF),
        ),
        surfaceTintColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey;
          }

          final color = Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF4285F4);

          return color;
        }),
      ),
      icon: ColorFiltered(
        colorFilter: onPressed != null
            ? const ColorFilter.mode(
                Colors.transparent,
                BlendMode.multiply,
              )
            : const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFFFFF),
          ),
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(googleLogoImage),
        ),
      ),
      label: const Text('Login com o Google'),
    );
  }
}
