import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/company_settings.dart';
import 'admin_login_dialog.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const settings = CompanySettings.defaultSettings;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.warmIvory.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: AppColors.iceBlue.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mochaBrown.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1152),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Company Name & Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settings.companyNameAr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        settings.shortDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mochaBrown.withValues(alpha: 0.70),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Contact Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactRow(Icons.location_on_outlined, settings.address),
                      const SizedBox(height: 8),
                      _buildContactRow(Icons.phone_outlined, settings.phone, isLtr: true),
                      const SizedBox(height: 8),
                      _buildContactRow(Icons.mail_outline, settings.email, isLtr: true),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0x33A0BDDB), height: 1),
                  const SizedBox(height: 20),

                  // Quick links grid
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _buildFooterLink(
                        context,
                        label: 'عقارات دمشق الفاخرة',
                        onTap: () => Navigator.of(context).pushNamed(
                          '/properties',
                          arguments: {'gov': 'damascus'},
                        ),
                      ),
                      _buildFooterLink(
                        context,
                        label: 'شقق للبيع في حلب',
                        onTap: () => Navigator.of(context).pushNamed(
                          '/properties',
                          arguments: {'gov': 'aleppo', 'type': 'apartment'},
                        ),
                      ),
                      _buildFooterLink(
                        context,
                        label: 'من نحن',
                        onTap: () => Navigator.of(context).pushNamed('/about'),
                      ),
                      _buildFooterLink(
                        context,
                        label: 'تواصل معنا',
                        onTap: () => Navigator.of(context).pushNamed('/contact'),
                      ),
                      _buildFooterLink(
                        context,
                        label: 'الاستشارات والتوثيق القانوني',
                        onTap: () => Navigator.of(context).pushNamed('/about'),
                      ),
                      _buildFooterLink(
                        context,
                        label: 'بوابة الإدارة',
                        onTap: () => showAdminLoginDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0x33A0BDDB), height: 1),
                  const SizedBox(height: 16),

                  // Copyright & Country
                  Column(
                    children: [
                      Text(
                        'جميع الحقوق محفوظة © 2026 ${settings.companyNameAr} ${settings.companyNameEn}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mochaBrown.withValues(alpha: 0.70),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الجمهورية العربية السورية',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, {bool isLtr = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mochaBrown),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            textDirection: isLtr ? TextDirection.ltr : null,
            textAlign: isLtr ? TextAlign.right : null,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.mochaBrown.withValues(alpha: 0.80),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, {required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.mochaBrown.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}
