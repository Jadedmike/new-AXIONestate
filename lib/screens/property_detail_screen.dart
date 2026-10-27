import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../models/company_settings.dart';
import '../models/property.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_container.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _selectedImageIndex = 0;

  List<String> get _galleryImages {
    if (widget.property.images.isNotEmpty) {
      return widget.property.images.map((img) => img.url).toList();
    }
    return [widget.property.imageUrl];
  }

  void _openWhatsApp() async {
    final phone = CompanySettings.defaultSettings.whatsapp;
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final msg =
        'مرحباً Axion Digital، أود الاستفسار عن العقار: ${widget.property.title} (كود: ${widget.property.id}).';
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _callPhone() async {
    final uri = Uri.parse('tel:${CompanySettings.defaultSettings.phone.replaceAll(" ", "")}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prop = widget.property;
    final images = _galleryImages;

    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      appBar: AppHeader(
        variant: HeaderVariant.back,
        title: prop.title,
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
                      // 1. Gallery Section
                      _buildGallery(images),

                      const SizedBox(height: 24),

                      // 2. Title, Badges & Price Header
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 768;
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: _buildTitleAndLocation(prop)),
                                const SizedBox(width: 24),
                                _buildPriceBox(prop),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildTitleAndLocation(prop),
                                const SizedBox(height: 16),
                                _buildPriceBox(prop),
                              ],
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // 3. Cadastral Status Alert Card
                      if (prop.cadastralStatus != null)
                        GlassContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(18),
                          color: AppColors.iceBlue.withValues(alpha: 0.15),
                          border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.45)),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.iceBlue.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.verified_user, color: AppColors.mochaBrown, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'توثيق قانوني معتمد 100%',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mochaBrown,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      prop.cadastralStatus!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.mochaBrown.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // 4. Specifications Grid
                      const Text(
                        'المواصفات الفنية والهندسية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSpecGrid(prop),

                      const SizedBox(height: 28),

                      // 5. Features & Amenities
                      if (prop.features.isNotEmpty) ...[
                        const Text(
                          'الميزات والتجهيزات المعمارية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mochaBrown,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GlassContainer(
                          padding: const EdgeInsets.all(20),
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: prop.features.map((feat) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        feat,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.mochaBrown,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // 6. Direct Contact & Booking Card
                      GlassContainer(
                        padding: const EdgeInsets.all(24),
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.warmSand.withValues(alpha: 0.65),
                        border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.support_agent, size: 24, color: AppColors.mochaBrown),
                                SizedBox(width: 8),
                                Text(
                                  'تواصل مع مستشار العقار في Axion Digital',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mochaBrown,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'فريقنا متواجد لترتيب معاينة ميدانية وتقديم الاستشارة القانونية والهندسية للعقار.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.mochaBrown.withValues(alpha: 0.75),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 12,
                              runSpacing: 10,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mochaBrown,
                                    foregroundColor: AppColors.warmIvory,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  icon: const Icon(Icons.chat, size: 18),
                                  label: const Text('مراسلة عبر واتساب'),
                                  onPressed: _openWhatsApp,
                                ),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColors.warmIvory.withValues(alpha: 0.8),
                                    foregroundColor: AppColors.mochaBrown,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  icon: const Icon(Icons.phone, size: 18),
                                  label: const Text('اتصال هاتفي مباشر'),
                                  onPressed: _callPhone,
                                ),
                              ],
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

  Widget _buildGallery(List<String> images) {
    return Column(
      children: [
        // Main Active Image
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 380,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.warmSand,
              border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
            ),
            child: Image.network(
              images[_selectedImageIndex],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.apartment, size: 60, color: AppColors.iceBlue),
              ),
            ),
          ),
        ),

        // Thumbnails Strip if multiple images
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final isSelected = idx == _selectedImageIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = idx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.mochaBrown : AppColors.iceBlue.withValues(alpha: 0.4),
                        width: isSelected ? 2.5 : 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[idx],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTitleAndLocation(Property prop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.mochaBrown,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                prop.dealType == 'sale' ? 'للبيع' : 'للإيجار',
                style: const TextStyle(
                  color: AppColors.warmIvory,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (prop.badgeHighlight != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.iceBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  prop.badgeHighlight!,
                  style: const TextStyle(
                    color: AppColors.mochaBrown,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          prop.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.mochaBrown,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.pin_drop, size: 18, color: AppColors.mochaBrown),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                prop.location,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mochaBrown.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceBox(Property prop) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderRadius: BorderRadius.circular(18),
      color: AppColors.warmIvory.withValues(alpha: 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'السعر المطلوب',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mochaBrown.withValues(alpha: 0.65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            prop.price,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.mochaBrown,
            ),
          ),
          if (prop.priceNote != null)
            Text(
              prop.priceNote!,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.mochaBrown.withValues(alpha: 0.70),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecGrid(Property prop) {
    final specs = prop.specs.isNotEmpty
        ? prop.specs
        : [
            PropertySpec(label: 'المساحة', value: prop.area, icon: 'square_foot'),
            PropertySpec(label: 'غرف النوم', value: '${prop.bedrooms} غرف', icon: 'bed'),
            PropertySpec(label: 'الحمامات', value: '${prop.bathrooms} حمامات', icon: 'bathtub'),
            if (prop.floor != null)
              PropertySpec(label: 'الطابق', value: prop.floor!, icon: 'layers'),
          ];

    IconData getIcon(String name) {
      switch (name) {
        case 'square_foot':
        case 'straighten':
          return Icons.square_foot;
        case 'bed':
          return Icons.bed;
        case 'bathtub':
          return Icons.bathtub;
        case 'layers':
          return Icons.layers;
        case 'verified_user':
          return Icons.verified_user;
        case 'garage':
          return Icons.garage;
        default:
          return Icons.info_outline;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int count = 2;
        if (constraints.maxWidth >= 800) {
          count = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final s = specs[index];
            return GlassContainer(
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.warmIvory.withValues(alpha: 0.8),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.iceBlue.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(getIcon(s.icon), size: 18, color: AppColors.mochaBrown),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.mochaBrown.withValues(alpha: 0.65),
                          ),
                        ),
                        Text(
                          s.value,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mochaBrown,
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
    );
  }
}
