import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../models/company_settings.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const settings = CompanySettings.defaultSettings;

    final pillars = [
      {
        'title': 'خبرة عقارية راسخة',
        'desc': 'فهم عميق ودقيق لحركة السوق العقاري السوري والتطورات العمرانية في دمشق والمحافظات.',
        'icon': Icons.history_edu,
      },
      {
        'title': 'توثيق قانوني معتمد',
        'desc': 'تدقيق شامل لسندات الملكية والبيانات المالية وضمان صحة العقود والمعاملات الرسمية.',
        'icon': Icons.verified_user,
      },
      {
        'title': 'تقييم هندسي دقيق',
        'desc': 'فريق هندسي متخصص لتقييم العقارات فنياً ومعمارياً لضمان السعر العادل والفرص الحقيقية.',
        'icon': Icons.architecture,
      },
      {
        'title': 'سرية واحترافية تامة',
        'desc': 'حماية تامة لخصوصية العملاء وسرية الصفقات الاستثمارية بأعلى معايير الأمانة والمصداقية.',
        'icon': Icons.security,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      appBar: const AppHeader(
        variant: HeaderVariant.back,
        title: 'من نحن',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1152),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Company Hero Card
                      GlassContainer(
                        padding: const EdgeInsets.all(28),
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.warmIvory.withValues(alpha: 0.85),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settings.companyNameAr,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mochaBrown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              settings.companyNameEn,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.mochaBrown.withValues(alpha: 0.65),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              settings.shortDescription,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.7,
                                color: AppColors.mochaBrown.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pillars of Trust
                      GlassContainer(
                        padding: const EdgeInsets.all(28),
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.iceBlue,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'أعمدة الثقة والمصداقية في Axion Digital',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mochaBrown,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth >= 700;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: pillars.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isWide ? 2 : 1,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: isWide ? 2.4 : 3.0,
                                  ),
                                  itemBuilder: (context, idx) {
                                    final p = pillars[idx];
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.warmSand.withValues(alpha: 0.55),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.iceBlue.withValues(alpha: 0.30),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: AppColors.iceBlue.withValues(alpha: 0.25),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.iceBlue.withValues(alpha: 0.45),
                                              ),
                                            ),
                                            child: Icon(
                                              p['icon'] as IconData,
                                              size: 22,
                                              color: AppColors.mochaBrown,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p['title'] as String,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.mochaBrown,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  p['desc'] as String,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    height: 1.4,
                                                    color: AppColors.mochaBrown.withValues(alpha: 0.75),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Syrian Cadastral Info Card
                      GlassContainer(
                        padding: const EdgeInsets.all(24),
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.warmSand.withValues(alpha: 0.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.gavel, size: 22, color: AppColors.mochaBrown),
                                SizedBox(width: 8),
                                Text(
                                  'منظومة التدقيق القانوني والعقاري في سوريا',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mochaBrown,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'تعتمد Axion Digital بروتوكول فحص صارم يشمل: التحقق المباشر من قيود السجل المؤقت والدوائر العقارية (طابو أخضر نظامي)، التأكد من براءة الذمة المالية، مطابقة المخططات الهندسية المعتمدة لدى نقابة المهندسين السوريين، وضمان عدم وجود أية إشارات أو حجوزات تعيق نقل الملكية.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.6,
                                color: AppColors.mochaBrown.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // CTA Button
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mochaBrown,
                            foregroundColor: AppColors.warmIvory,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.chat, size: 20),
                          label: const Text(
                            'تواصل مباشرة مع إدارة Axion Digital',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          onPressed: () {
                            final phone = settings.whatsapp;
                            final clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
                            launchUrl(
                              Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent("مرحباً Axion Digital، أود الاستفسار عن خدماتكم.")}'),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
