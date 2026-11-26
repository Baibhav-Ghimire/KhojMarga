import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.text = 'OR'});

  final String text;

  @override
  Widget build(BuildContext context) {
    const line = Expanded(child: Divider(color: AppColors.softGrey, height: 1));
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
