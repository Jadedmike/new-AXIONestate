import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'admin_login_dialog.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final bool isEndDrawer;
  final Function(String route, {Map<String, String>? queryParams})? onNavigate;

  const AppDrawer({
    super.key,
    this.currentRoute = '/',
    this.isEndDrawer = false,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final navLinks = [
      {'label': 'الرئيسية', 'route': '/', 'icon': Icons.roofing},
      {'label': 'العقارات', 'route': '/properties', 'icon': Icons.apartment},
      {'label': 'عقارات للبيع', 'route': '/properties', 'deal': 'sale', 'icon': Icons.sell},
      {'label': 'عقارات للإيجار', 'route': '/properties', 'deal': 'rent', 'icon': Icons.key},
      {'label': 'استكشف المناطق', 'route': '/regions', 'icon': Icons.map},
      {'label': 'من نحن', 'route': '/about', 'icon': Icons.domain},
      {'label': 'تواصل معنا', 'route': '/contact', 'icon': Icons.chat},
    ];

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    // Determine inner edge for rounded corners & shadow:
    // If drawer is on the right side of the screen, inner edge is LEFT.
    // If drawer is on the left side of the screen, inner edge is RIGHT.
    final isOnRight = (!isRtl && isEndDrawer) || (isRtl && !isEndDrawer);

    final innerRadius = isOnRight
        ? const BorderRadius.horizontal(left: Radius.circular(24))
        : const BorderRadius.horizontal(right: Radius.circular(24));

    final innerBorder = isOnRight
        ? Border(left: BorderSide(color: AppColors.iceBlue.withValues(alpha: 0.30), width: 1.0))
        : Border(right: BorderSide(color: AppColors.iceBlue.withValues(alpha: 0.30), width: 1.0));

    final shadowOffset = isOnRight ? const Offset(-10, 0) : const Offset(10, 0);

    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      width: 320,
      child: ClipRRect(
        borderRadius: innerRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.warmIvory.withValues(alpha: 0.45), // Specified translucent fill
              border: innerBorder,
              boxShadow: [
                BoxShadow(
                  color: AppColors.mochaBrown.withValues(alpha: 0.14),
                  blurRadius: 40,
                  offset: shadowOffset,
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Drawer Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Axion Digital',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mochaBrown,
                              ),
                            ),
                            Text(
                              'القائمة الرئيسية',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.mochaBrown.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.iceBlue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close, size: 20),
                            color: AppColors.mochaBrown,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: Color(0x33A0BDDB), height: 1),

                  // Navigation Links List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      children: navLinks.map((item) {
                        final route = item['route'] as String;
                        final label = item['label'] as String;
                        final icon = item['icon'] as IconData;
                        final deal = item['deal'] as String?;
                        final isActive = currentRoute == route && deal == null;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.iceBlue.withValues(alpha: 0.35)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.iceBlue.withValues(alpha: 0.50)
                                  : Colors.transparent,
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              icon,
                              color: AppColors.mochaBrown,
                              size: 20,
                            ),
                            title: Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                color: AppColors.mochaBrown,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            hoverColor: AppColors.iceBlue.withValues(alpha: 0.15),
                            onTap: () {
                              Navigator.of(context).pop();
                              if (onNavigate != null) {
                                onNavigate!(
                                  route,
                                  queryParams: deal != null ? {'deal': deal} : null,
                                );
                              } else {
                                if (route == '/regions') {
                                  Navigator.of(context).pushNamed('/', arguments: {'scroll': 'regions'});
                                } else {
                                  Navigator.of(context).pushNamed(
                                    route,
                                    arguments: deal != null ? {'deal': deal} : null,
                                  );
                                }
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Quick Contact Footer in Drawer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.iceBlue.withValues(alpha: 0.30),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تواصل مباشر على مدار الساعة',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mochaBrown.withValues(alpha: 0.70),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // "اتصل بنا" Button
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mochaBrown,
                                  foregroundColor: AppColors.warmIvory,
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppColors.iceBlue.withValues(alpha: 0.20),
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.mail, size: 16),
                                label: const Text(
                                  'اتصل بنا',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed('/contact');
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // "الإدارة" Button
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.warmIvory.withValues(alpha: 0.80),
                                  foregroundColor: AppColors.mochaBrown,
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                  side: BorderSide(
                                    color: AppColors.iceBlue.withValues(alpha: 0.35),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.admin_panel_settings, size: 16),
                                label: const Text(
                                  'الإدارة',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showAdminLoginDialog(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
