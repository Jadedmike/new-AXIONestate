import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/company_settings.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_container.dart';
import '../widgets/property_card.dart';
import '../widgets/search_filters_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _regionsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openWhatsApp(String message) async {
    final phone = CompanySettings.defaultSettings.whatsapp;
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح تطبيق الواتساب')),
        );
      }
    }
  }

  void scrollToRegions() {
    Scrollable.ensureVisible(
      _regionsKey.currentContext ?? context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final offers = MockData.properties.where((p) => p.isOffer).toList();
    final featured = MockData.properties.where((p) => p.isFeatured).toList();
    final latest = MockData.properties.toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.warmIvory,
      // Rule 4: Toggleable drawer on-demand on all screen sizes with custom 500ms slide transition
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      drawer: AppDrawer(
        currentRoute: '/',
        isEndDrawer: false,
        onNavigate: (route, {queryParams}) {
          if (route == '/regions') {
            scrollToRegions();
          } else {
            Navigator.of(context).pushNamed(route, arguments: queryParams);
          }
        },
      ),
      endDrawer: AppDrawer(
        currentRoute: '/',
        isEndDrawer: true,
        onNavigate: (route, {queryParams}) {
          if (route == '/regions') {
            scrollToRegions();
          } else {
            Navigator.of(context).pushNamed(route, arguments: queryParams);
          }
        },
      ),
      appBar: AppHeader(
        currentRoute: '/',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // 1. Hero Section
            _buildHeroSection(),

            // 2. Interactive Search Box
            Transform.translate(
              offset: const Offset(0, -32),
              child: const SearchFiltersBar(),
            ),

            // Constrained Container for Sections
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1152),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 3. Special Offers Section
                      if (offers.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSectionHeader(
                          badgeIcon: Icons.local_fire_department,
                          badgeText: 'فرص عقارية مختارة لفترة محدودة',
                          title: 'عروض حصرية مميزة',
                          tag: 'CMS حي',
                        ),
                        const SizedBox(height: 16),
                        _buildPropertyGrid(offers),
                      ],

                      // 4. Featured Properties Section
                      const SizedBox(height: 48),
                      _buildSectionHeader(
                        title: 'عقارات مميزة مختارة',
                        subtitle: 'تم تدقيق ملكيتها وتوثيقها قانونياً من فريق Axion Digital',
                        actionText: 'عرض الكل',
                        onAction: () => Navigator.of(context).pushNamed('/properties'),
                      ),
                      const SizedBox(height: 16),
                      _buildPropertyGrid(featured),

                      // 5. Locations / Governorates Section
                      const SizedBox(height: 48),
                      Container(key: _regionsKey),
                      _buildSectionHeader(
                        title: 'استكشف العقارات حسب المحافظة',
                        subtitle: 'تغطية شاملة لأهم المدن والمراكز الاستثمارية السورية',
                      ),
                      const SizedBox(height: 16),
                      _buildGovernoratesGrid(),

                      // 6. Property Types Section
                      const SizedBox(height: 48),
                      _buildSectionHeader(
                        title: 'تصفح حسب نوع العقار',
                        subtitle: 'خيارات متنوعة تلبي تطلعات السكن والاستثمار التجاري',
                      ),
                      const SizedBox(height: 16),
                      _buildPropertyTypesGrid(),

                      // 7. Why Axion Digital Section
                      const SizedBox(height: 48),
                      _buildWhyAxionSection(),

                      // 8. Latest Properties Section
                      const SizedBox(height: 48),
                      _buildSectionHeader(
                        title: 'أحدث العقارات المضافة',
                        subtitle: 'أحدث العروض المسجلة في السجل اليومي',
                        actionText: 'عرض الكل',
                        onAction: () => Navigator.of(context).pushNamed('/properties'),
                      ),
                      const SizedBox(height: 16),
                      _buildPropertyGrid(latest.take(6).toList()),

                      // 9. CTA Banner
                      const SizedBox(height: 48),
                      _buildCtaBanner(),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),

            // Persistent Syrian Real Estate Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      color: AppColors.mochaBrown,
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBRp9VHpaEzBhXGu9i0azr_4wkfPjiMzoaQPN8F9wYrPwbf4MV51pqa9aXipNm0V5ObCsB4WGQoYMYEXrRQsprhZXp21TYOcuJI3esK6Vh8HVIavldJCNwilqbNw3Bqj6BUmLcXUHZ05lN0PptDAYnTk_rOd5-_rkNY_cZ6eyRg67knWkoNNMBK7q7xPRwR0ZjCxFsgSCWQNImR6y84Xr7haOamoQpc4OAHxj5zXj7Y9fOmiO-5h9Te',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.mochaBrown,
                    AppColors.mochaBrown.withValues(alpha: 0.80),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Hero Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1152),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verified Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.iceBlue.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.iceBlue.withValues(alpha: 0.45),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 16, color: AppColors.warmIvory),
                          SizedBox(width: 6),
                          Text(
                            'الرائد الأول للعقارات الفاخرة في سوريا',
                            style: TextStyle(
                              color: AppColors.warmIvory,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Headline
                    const Text(
                      'اكتشف عقارك القادم في سوريا',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warmIvory,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 580),
                      child: Text(
                        'مجموعة مميزة من العقارات للبيع والإيجار في مختلف المحافظات السورية بأعلى معايير المصداقية والاحترافية المعمارية.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: AppColors.warmIvory.withValues(alpha: 0.85),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.iceBlue,
                            foregroundColor: AppColors.mochaBrown,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.travel_explore, size: 20),
                          label: const Text(
                            'استكشف العقارات',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          onPressed: () => Navigator.of(context).pushNamed('/properties'),
                        ),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.warmIvory.withValues(alpha: 0.15),
                            foregroundColor: AppColors.warmIvory,
                            side: BorderSide(
                              color: AppColors.iceBlue.withValues(alpha: 0.35),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.add_business, size: 20),
                          label: const Text(
                            'أضف عقارك',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          onPressed: () => _openWhatsApp(
                            'مرحباً Axion Digital، أرغب في إضافة عقاري للبيع أو الإيجار.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    IconData? badgeIcon,
    String? badgeText,
    required String title,
    String? subtitle,
    String? tag,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badgeText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    if (badgeIcon != null) ...[
                      Icon(badgeIcon, size: 15, color: AppColors.mochaBrown),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mochaBrown.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.mochaBrown,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.mochaBrown.withValues(alpha: 0.70),
                ),
              ),
            ],
          ],
        ),
        if (tag != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.iceBlue.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.45)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.mochaBrown,
              ),
            ),
          ),
        if (actionText != null && onAction != null)
          InkWell(
            onTap: onAction,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mochaBrown,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_back, size: 16, color: AppColors.mochaBrown),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPropertyGrid(List<dynamic> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        double childAspectRatio = 1.15;

        if (constraints.maxWidth >= 960) {
          crossAxisCount = 3;
          childAspectRatio = 1.02;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
          childAspectRatio = 1.05;
        } else {
          crossAxisCount = 1;
          childAspectRatio = 1.18;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final prop = items[index];
            return PropertyCard(property: prop);
          },
        );
      },
    );
  }

  Widget _buildGovernoratesGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth >= 1000) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 650) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.governorates.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index) {
            final gov = MockData.governorates[index];
            return InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                '/properties',
                arguments: {'gov': gov.id},
              ),
              borderRadius: BorderRadius.circular(18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    if (gov.image != null)
                      Positioned.fill(
                        child: Image.network(
                          gov.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.mochaBrown.withValues(alpha: 0.95),
                              AppColors.mochaBrown.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 14,
                      left: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gov.nameAr,
                            style: const TextStyle(
                              color: AppColors.warmIvory,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${gov.propertyCount} عقار موثق',
                            style: TextStyle(
                              color: AppColors.warmIvory.withValues(alpha: 0.85),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPropertyTypesGrid() {
    final types = [
      {'title': 'شقق سكنية', 'icon': Icons.apartment, 'type': 'apartment'},
      {'title': 'فلل وقصور', 'icon': Icons.villa, 'type': 'villa'},
      {'title': 'مكاتب إدارية', 'icon': Icons.corporate_fare, 'type': 'office'},
      {'title': 'محلات تجارية', 'icon': Icons.storefront, 'type': 'shop'},
      {'title': 'أراضٍ ومزارع', 'icon': Icons.landscape, 'type': 'land'},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int count = 2;
        if (constraints.maxWidth >= 900) {
          count = 5;
        } else if (constraints.maxWidth >= 550) {
          count = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: types.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            final t = types[index];
            return GlassContainer(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.warmIvory.withValues(alpha: 0.80),
              border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
              onTap: () => Navigator.of(context).pushNamed(
                '/properties',
                arguments: {'type': t['type']},
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.iceBlue.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.45)),
                    ),
                    child: Icon(
                      t['icon'] as IconData,
                      size: 24,
                      color: AppColors.mochaBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t['title'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mochaBrown,
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

  Widget _buildWhyAxionSection() {
    final pillars = [
      {
        'icon': Icons.verified_user,
        'title': 'خبرة وتوثيق قانوني 100%',
        'desc': 'دراسة دقيقة لسجلات الطابو والوكالات والتنظيم العقاري لحماية استثمارك بالكامل.',
      },
      {
        'icon': Icons.real_estate_agent,
        'title': 'خيارات عقارية حصرية',
        'desc': 'عقارات نوعية لا تُعرض في السوق المفتوح، محفوظة لعملاء Axion Digital VIP حصرياً.',
      },
      {
        'icon': Icons.touch_app,
        'title': 'تجربة بحث رقمية سهلة',
        'desc': 'نظام بحث هرمي دقيق ومواكب لأحدث تقنيات تصفح العقار بجولات واقعية.',
      },
      {
        'icon': Icons.support_agent,
        'title': 'تواصل مباشر وسريع',
        'desc': 'فريق استشاري متاح على مدار الساعة عبر الواتساب والمكالمات في دمشق وحلب والساحل.',
      },
    ];

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      color: AppColors.warmIvory.withValues(alpha: 0.80),
      child: Column(
        children: [
          Text(
            'ثقة ومصداقية تتوارثها الأجيال',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.mochaBrown.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'لماذا تختار Axion Digital؟',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.mochaBrown,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 1;
              if (constraints.maxWidth >= 900) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth >= 550) {
                crossAxisCount = 2;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pillars.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: crossAxisCount == 1 ? 3.5 : 1.4,
                ),
                itemBuilder: (context, index) {
                  final p = pillars[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.iceBlue.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.45)),
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
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mochaBrown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p['desc'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: AppColors.mochaBrown.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCtaBanner() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mochaBrown.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.iceBlue.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.mochaBrown.withValues(alpha: 0.20),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.real_estate_agent, size: 36, color: AppColors.iceBlue),
          const SizedBox(height: 12),
          const Text(
            'هل ترغب ببيع أو تأجير عقارك في سوريا؟',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.warmIvory,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'نضع عقارك أمام آلاف المستثمرين والمشترين الجادين داخل وخارج سوريا مع تسويق احترافي عالي المستوى.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.warmIvory.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.iceBlue,
                  foregroundColor: AppColors.mochaBrown,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text(
                  'أضف عقارك الآن عبر واتساب Axion Digital',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: () => _openWhatsApp(
                  'مرحباً Axion Digital، أرغب في إضافة عقار جديد للتسويق.',
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.warmIvory.withValues(alpha: 0.15),
                  foregroundColor: AppColors.warmIvory,
                  side: BorderSide(color: AppColors.iceBlue.withValues(alpha: 0.35)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text(
                  'اتصال مباشر مع الإدارة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: () => launchUrl(
                  Uri.parse('tel:${CompanySettings.defaultSettings.phone.replaceAll(" ", "")}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
