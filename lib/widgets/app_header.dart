import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum HeaderVariant { standard, back }

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final HeaderVariant variant;
  final String title;
  final VoidCallback? onMenuPressed;
  final String currentRoute;

  const AppHeader({
    super.key,
    this.variant = HeaderVariant.standard,
    this.title = 'Axion Digital',
    this.onMenuPressed,
    this.currentRoute = '/',
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 840;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.warmIvory.withValues(alpha: 0.85),
            border: Border(
              bottom: BorderSide(
                color: AppColors.iceBlue.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mochaBrown.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (variant == HeaderVariant.back) ...[
                      // Back variant
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_forward), // RTL back arrow
                            color: AppColors.mochaBrown,
                            tooltip: 'رجوع',
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pushReplacementNamed('/');
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mochaBrown,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Axion Digital',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/'),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.iceBlue.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida/AEtjO1VjHL3Xf69kKeZ2xN9LEEp_CJhkGWahcs3SdbNz42Ho-ZCUl-VOAx1aanObqYHxHP1_oTyp_HspbW7HxAHwqJdeGxsZC-V6YN40OqTxm2COSTX7mGTh2OJHy4NjVTDleOUQ15RMMkM1RWE7DPUo4pH8LQNXBKrIE3Pyk2AN1JKybTOfOCHqqTokQfbfnbllNHxUyuNa8AeYaGz12yu3TjDQPZUYmdo95LVgkxIw2T6HTgMfUyaHzeGDRqied-_JBDYl_cGvXdxR',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Standard variant
                      Row(
                        children: [
                          // Menu button on mobile
                          if (!isDesktop)
                            IconButton(
                              icon: const Icon(Icons.menu),
                              color: AppColors.mochaBrown,
                              tooltip: 'القائمة',
                              onPressed: onMenuPressed,
                            ),
                          // Brand Identity
                          InkWell(
                            onTap: () {
                              if (currentRoute != '/') {
                                Navigator.of(context).pushNamed('/');
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                'Axion Digital',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mochaBrown,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Desktop Navigation Links
                      // Rule: Do NOT include "تواصل معنا" plain text link in the top nav items;
                      // keep only the dedicated contact button on the side.
                      if (isDesktop)
                        Row(
                          children: [
                            _buildNavLink(
                              context,
                              label: 'الرئيسية',
                              route: '/',
                              isActive: currentRoute == '/',
                            ),
                            const SizedBox(width: 8),
                            _buildNavLink(
                              context,
                              label: 'العقارات',
                              route: '/properties',
                              isActive: currentRoute.startsWith('/properties'),
                            ),
                            const SizedBox(width: 8),
                            _buildNavLink(
                              context,
                              label: 'من نحن',
                              route: '/about',
                              isActive: currentRoute == '/about',
                            ),
                          ],
                        ),

                      // Actions on other side: Dedicated Contact & Support Button
                      Row(
                        children: [
                          Tooltip(
                            message: 'اتصال وتواصل',
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                hoverColor: AppColors.iceBlue.withValues(alpha: 0.15),
                                onTap: () {
                                  if (currentRoute != '/contact') {
                                    Navigator.of(context).pushNamed('/contact');
                                  }
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.support_agent,
                                    size: 22,
                                    color: AppColors.mochaBrown,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isDesktop) ...[
                            const SizedBox(width: 8),
                            Tooltip(
                              message: 'القائمة الكاملة',
                              child: IconButton(
                                icon: const Icon(Icons.menu_open),
                                color: AppColors.mochaBrown,
                                onPressed: onMenuPressed,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(
    BuildContext context, {
    required String label,
    required String route,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          Navigator.of(context).pushNamed(route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.iceBlue.withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.iceBlue.withValues(alpha: 0.50) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: AppColors.mochaBrown,
          ),
        ),
      ),
    );
  }
}
