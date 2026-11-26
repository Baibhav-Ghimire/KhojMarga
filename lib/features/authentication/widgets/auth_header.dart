import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Replace with Image.asset('assets/images/logo.png') to use the
        // real Margaखोज logo.
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.terrain_rounded,
              color: AppColors.white, size: 24),
        ),
        const SizedBox(width: 10),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            children: [
              TextSpan(text: 'Marga', style: TextStyle(color: AppColors.navy)),
              TextSpan(text: 'खोज', style: TextStyle(color: AppColors.orange)),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBack) ...[
          Material(
            color: AppColors.white,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.softGrey),
            ),
            child: IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          const SizedBox(height: 20),
        ],
        const BrandLogo(),
        const SizedBox(height: 32),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
