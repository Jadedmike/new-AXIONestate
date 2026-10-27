import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../models/company_settings.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_container.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String _inquiryType = 'معاينة عقار معروض';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.mochaBrown,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.iceBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'شكراً لك! تم استلام طلبك وسيتواصل معك مستشار Axion Digital قريباً.',
                  style: TextStyle(color: AppColors.warmIvory, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        _nameController.clear();
        _phoneController.clear();
        _notesController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const settings = CompanySettings.defaultSettings;

    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      appBar: const AppHeader(
        variant: HeaderVariant.back,
        title: 'تواصل معنا',
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
                      // Header Banner
                      GlassContainer(
                        padding: const EdgeInsets.all(24),
                        borderRadius: BorderRadius.circular(22),
                        color: AppColors.warmIvory.withValues(alpha: 0.85),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.support_agent, size: 24, color: AppColors.mochaBrown),
                                SizedBox(width: 8),
                                Text(
                                  'خدمة العملاء والاستشارات المعتمدة',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mochaBrown,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'تواصل مع ${settings.companyNameAr}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mochaBrown,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              settings.shortDescription,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.mochaBrown.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Direct Actions Grid (Phone, WhatsApp, Email)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 700;
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: isWide ? 3 : 1,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: isWide ? 2.3 : 3.5,
                            children: [
                              _buildActionCard(
                                icon: Icons.call,
                                title: 'اتصال هاتفي',
                                subtitle: settings.phone,
                                onTap: () => launchUrl(
                                  Uri.parse('tel:${settings.phone.replaceAll(" ", "")}'),
                                ),
                              ),
                              _buildActionCard(
                                icon: Icons.chat,
                                title: 'واتساب مباشر',
                                subtitle: settings.whatsapp,
                                onTap: () {
                                  final clean = settings.whatsapp.replaceAll(RegExp(r'[^\d+]'), '');
                                  launchUrl(
                                    Uri.parse('https://wa.me/$clean?text=${Uri.encodeComponent("مرحباً Axion Digital، أرغب في الاستفسار عن خدماتكم.")}'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              ),
                              _buildActionCard(
                                icon: Icons.mail_outline,
                                title: 'البريد الإلكتروني',
                                subtitle: settings.email,
                                onTap: () => launchUrl(Uri.parse('mailto:${settings.email}')),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // Consultation / Inquiry Booking Form
                      GlassContainer(
                        padding: const EdgeInsets.all(28),
                        borderRadius: BorderRadius.circular(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'حجز موعد أو استشارة عقارية',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mochaBrown,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'أرسل تفاصيل طلبك وسنقوم بترتيب جلسة استشارية أو جولة ميدانية متخصصة.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mochaBrown.withValues(alpha: 0.70),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Name Field
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(fontSize: 14, color: AppColors.mochaBrown),
                                decoration: const InputDecoration(
                                  labelText: 'الاسم الكامل',
                                  hintText: 'مثال: المهندس أحمد السعيد',
                                  prefixIcon: Icon(Icons.person_outline, size: 20),
                                ),
                                validator: (val) => val == null || val.trim().isEmpty ? 'يرجى كتابة الاسم' : null,
                              ),

                              const SizedBox(height: 14),

                              // Phone Field
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(fontSize: 14, color: AppColors.mochaBrown),
                                decoration: const InputDecoration(
                                  labelText: 'رقم الهاتف أو الواتساب',
                                  hintText: '+963 944 000 000',
                                  prefixIcon: Icon(Icons.phone_outlined, size: 20),
                                ),
                                validator: (val) => val == null || val.trim().isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                              ),

                              const SizedBox(height: 14),

                              // Inquiry Type Dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.warmIvory.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.glassBorder),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _inquiryType,
                                    items: const [
                                      DropdownMenuItem(value: 'معاينة عقار معروض', child: Text('معاينة عقار معروض في المنصة')),
                                      DropdownMenuItem(value: 'استشارة شراء واستثمار', child: Text('استشارة شراء واستثمار عقاري')),
                                      DropdownMenuItem(value: 'عرض عقار للبيع أو الإيجار', child: Text('عرض عقار للبيع أو الإيجار عبر المنصة')),
                                      DropdownMenuItem(value: 'توثيق وتدقيق قانوني', child: Text('توثيق وتدقيق ملكية وسندات طابو')),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) setState(() => _inquiryType = val);
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Notes
                              TextFormField(
                                controller: _notesController,
                                maxLines: 3,
                                style: const TextStyle(fontSize: 14, color: AppColors.mochaBrown),
                                decoration: const InputDecoration(
                                  labelText: 'ملاحظات أو مواصفات العقار المطلوب',
                                  hintText: 'اذكر المنطقة المفضلة، الميزانية، أو أية متطلبات خاصة...',
                                ),
                              ),

                              const SizedBox(height: 22),

                              // Submit
                              ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitForm,
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.warmIvory),
                                      )
                                    : const Text(
                                        'إرسال الطلب الآن',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Office Headquarters Card
                      GlassContainer(
                        padding: const EdgeInsets.all(24),
                        borderRadius: BorderRadius.circular(22),
                        color: AppColors.warmSand.withValues(alpha: 0.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_city, size: 22, color: AppColors.mochaBrown),
                                SizedBox(width: 8),
                                Text(
                                  'المقر الرئيسي والمكتب الاستشاري',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.mochaBrown),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              settings.address,
                              style: TextStyle(fontSize: 13, color: AppColors.mochaBrown.withValues(alpha: 0.85)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'أوقات الدوام الرسمي: السبت إلى الخميس، من الساعة 10:00 صباحاً وحتى 8:00 مساءً.',
                              style: TextStyle(fontSize: 12, color: AppColors.mochaBrown.withValues(alpha: 0.7)),
                            ),
                          ],
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

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      borderRadius: BorderRadius.circular(18),
      color: AppColors.warmSand.withValues(alpha: 0.6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.iceBlue.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.45)),
              ),
              child: Icon(icon, size: 22, color: AppColors.mochaBrown),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.mochaBrown),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mochaBrown.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
