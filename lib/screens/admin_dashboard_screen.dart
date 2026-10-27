import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/company_settings.dart';
import '../models/property.dart';
import '../widgets/glass_container.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _activeTabIndex = 0;
  late List<Property> _properties;
  late List<Map<String, dynamic>> _inquiries;
  CompanySettings _settings = CompanySettings.defaultSettings;

  // Search and filter inside properties tab
  final TextEditingController _searchController = TextEditingController();
  String _filterDeal = 'all';
  String _filterGov = 'all';

  // Add Property Form Controllers
  final _addFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _bedroomsController = TextEditingController(text: '3');
  final _bathroomsController = TextEditingController(text: '2');
  final _floorController = TextEditingController(text: 'الطابق الثاني');
  final _imageUrlController = TextEditingController(
    text:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCSWtAtXRGsv70NCoiYsysetiwxVmB1ILOf8gvsDHd5dDNyawUicdD9ICCg-Xf4yYWq3tNN3UXA9Nr5aQUIkDnozAlpZ1yxfUcx2RFUnwQ-M095yb6YpOAZqVFqKj46zXQG2FXOOMetDOGSiHW9xkHSAFnzvfJIDO0iYHrY2Rs-lO7VWbcSk0wtcVEVkkQXlq-D2J4TalAyuXawmkZ3c6MoOcQJHZrX5KOfMAZ3VNtb-uWMRgBWV1jy',
  );
  String _addGov = 'damascus';
  String _addType = 'apartment';
  String _addDeal = 'sale';
  String _addCadastral = 'طابو أخضر نظامي 2400 سهم بريء الذمة';

  // Company Settings Form Controllers
  final _companyNameArController = TextEditingController(text: CompanySettings.defaultSettings.companyNameAr);
  final _companyNameEnController = TextEditingController(text: CompanySettings.defaultSettings.companyNameEn);
  final _phoneController = TextEditingController(text: CompanySettings.defaultSettings.phone);
  final _whatsappController = TextEditingController(text: CompanySettings.defaultSettings.whatsapp);
  final _emailController = TextEditingController(text: CompanySettings.defaultSettings.email);
  final _addressController = TextEditingController(text: CompanySettings.defaultSettings.address);
  final _descController = TextEditingController(text: CompanySettings.defaultSettings.shortDescription);

  @override
  void initState() {
    super.initState();
    _properties = List.from(MockData.properties);
    _inquiries = [
      {
        'id': 'inq-1',
        'clientName': 'المهندس رامي الخوري',
        'phone': '+963 944 887 766',
        'propertyTitle': 'شقة فاخرة بإطلالة مفتوحة في المالكي',
        'type': 'معاينة ميدانية',
        'status': 'جديد',
        'date': 'اليوم 10:30 ص',
      },
      {
        'id': 'inq-2',
        'clientName': 'الدكتور سامر الأتاسي',
        'phone': '+963 933 554 433',
        'propertyTitle': 'قصر مصغر مع مسبح خاص في يعفور',
        'type': 'استفسار وتفاوض',
        'status': 'قيد المتابعة',
        'date': 'أمس 04:15 م',
      },
      {
        'id': 'inq-3',
        'clientName': 'السيد عماد بيطار',
        'phone': '+963 988 112 233',
        'propertyTitle': 'مقر إداري ومكتب تجاري في حلب الجديدة',
        'type': 'استشارة شراء',
        'status': 'مكتمل',
        'date': 'منذ 3 أيام',
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _floorController.dispose();
    _imageUrlController.dispose();
    _companyNameArController.dispose();
    _companyNameEnController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showNotificationSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF34211B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFA0BDDB), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(color: Color(0xFFF8F6F0), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProperty(Property prop) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF8F6F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: AppColors.error),
            SizedBox(width: 8),
            Text('تأكيد حذف العقار', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF34211B))),
          ],
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف "${prop.title}" نهائياً من قاعدة البيانات؟',
          style: const TextStyle(color: Color(0xFF34211B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء', style: TextStyle(color: Color(0xFF34211B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _properties.removeWhere((p) => p.id == prop.id);
              });
              _showNotificationSnackBar('تم حذف العقار "${prop.title}" بنجاح.');
            },
            child: const Text('نعم، حذف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _editProperty(Property prop) {
    final titleEdit = TextEditingController(text: prop.title);
    final priceEdit = TextEditingController(text: prop.price);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF8F6F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تعديل بيانات العقار', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF34211B))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleEdit,
              decoration: const InputDecoration(labelText: 'عنوان العقار'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceEdit,
              decoration: const InputDecoration(labelText: 'السعر المطلوب'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء', style: TextStyle(color: Color(0xFF34211B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34211B),
              foregroundColor: const Color(0xFFF8F6F0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                final index = _properties.indexWhere((p) => p.id == prop.id);
                if (index != -1) {
                  _properties[index] = Property(
                    id: prop.id,
                    title: titleEdit.text,
                    location: prop.location,
                    governorate: prop.governorate,
                    district: prop.district,
                    dealType: prop.dealType,
                    propertyType: prop.propertyType,
                    price: priceEdit.text,
                    priceNumeric: prop.priceNumeric,
                    badges: prop.badges,
                    area: prop.area,
                    bedrooms: prop.bedrooms,
                    bathrooms: prop.bathrooms,
                    publishedTime: prop.publishedTime,
                    imageUrl: prop.imageUrl,
                    imageAlt: prop.imageAlt,
                    cadastralStatus: prop.cadastralStatus,
                    features: prop.features,
                    isFeatured: prop.isFeatured,
                    isOffer: prop.isOffer,
                  );
                }
              });
              _showNotificationSnackBar('تم حفظ تعديلات العقار بنجاح.');
            },
            child: const Text('حفظ التعديلات', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _saveNewProperty() {
    if (_addFormKey.currentState?.validate() ?? false) {
      final newId = 'prop-${DateTime.now().millisecondsSinceEpoch}';
      final newProperty = Property(
        id: newId,
        title: _titleController.text.trim(),
        location: 'دمشق — سوريا',
        governorate: _addGov,
        district: 'all',
        dealType: _addDeal,
        propertyType: _addType,
        price: '\$${_priceController.text.trim()}',
        priceNumeric: double.tryParse(_priceController.text.replaceAll(',', '')) ?? 100000,
        badges: [_addDeal == 'sale' ? 'للبيع' : 'للإيجار', 'طابو أخضر'],
        area: '${_areaController.text.trim()} م²',
        bedrooms: _bedroomsController.text.trim(),
        bathrooms: _bathroomsController.text.trim(),
        floor: _floorController.text.trim(),
        publishedTime: 'الآن',
        imageUrl: _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : 'https://lh3.googleusercontent.com/aida-public/AB6AXuCSWtAtXRGsv70NCoiYsysetiwxVmB1ILOf8gvsDHd5dDNyawUicdD9ICCg-Xf4yYWq3tNN3UXA9Nr5aQUIkDnozAlpZ1yxfUcx2RFUnwQ-M095yb6YpOAZqVFqKj46zXQG2FXOOMetDOGSiHW9xkHSAFnzvfJIDO0iYHrY2Rs-lO7VWbcSk0wtcVEVkkQXlq-D2J4TalAyuXawmkZ3c6MoOcQJHZrX5KOfMAZ3VNtb-uWMRgBWV1jy',
        imageAlt: _titleController.text.trim(),
        cadastralStatus: _addCadastral,
        features: [
          'توثيق قانوني فوري معتمد',
          'موقف سيارة مخصص في القبو',
          'إطلالة مميزة وموقع حيوي',
        ],
        isFeatured: true,
      );

      setState(() {
        _properties.insert(0, newProperty);
        _activeTabIndex = 1; // Switch to properties table tab to inspect
      });

      _titleController.clear();
      _priceController.clear();
      _areaController.clear();

      _showNotificationSnackBar('تم إضافة ونشر العقار الجديد في السجل العام بنجاح!');
    }
  }

  void _saveSettings() {
    setState(() {
      _settings = CompanySettings(
        companyNameAr: _companyNameArController.text.trim(),
        companyNameEn: _companyNameEnController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
        email: _emailController.text.trim(),
        shortDescription: _descController.text.trim(),
      );
    });
    _showNotificationSnackBar('تم تحديث إعدادات وهوية المنصة بنجاح.');
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'label': 'نظرة عامة', 'icon': Icons.dashboard_outlined},
      {'label': 'قائمة العقارات', 'icon': Icons.apartment_outlined},
      {'label': 'إضافة عقار', 'icon': Icons.add_circle_outline},
      {'label': 'الطلبات', 'icon': Icons.assignment_outlined},
      {'label': 'الإحصائيات', 'icon': Icons.analytics_outlined},
      {'label': 'الإعدادات', 'icon': Icons.settings_outlined},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row 1: Brand title, online status badge, and top utilities
                  _buildHeaderRow1(context),

                  const SizedBox(height: 16),

                  // Row 2: Navigation tabs inside SingleChildScrollView with spacing
                  _buildHeaderRow2(tabs),

                  const SizedBox(height: 24),

                  // Tab Views with zero RenderFlex overflow
                  IndexedStack(
                    index: _activeTabIndex,
                    children: [
                      _buildOverviewTab(),
                      _buildPropertiesTableTab(),
                      _buildAddPropertyTab(),
                      _buildInquiriesTab(),
                      _buildAnalyticsTab(),
                      _buildSettingsTab(),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Row 1: Header Brand, Status Badge, and Top Utilities
  Widget _buildHeaderRow1(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA0BDDB).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.45)),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Color(0xFF34211B), size: 20),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth > 60 ? constraints.maxWidth - 60 : constraints.maxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Axion Digital CMS | الإدارة المركزية',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34211B),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'جلسة مشفرة ومباشرة • متصل الآن',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color(0xFF34211B).withValues(alpha: 0.65),
                                  fontWeight: FontWeight.w500,
                                ),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF34211B), size: 22),
                  tooltip: 'التنبيهات',
                  onPressed: () => _showNotificationSnackBar('لديك 3 تنبيهات جديدة حول طلبات المعاينة الميدانية.'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF34211B),
                    side: BorderSide(color: const Color(0xFFA0BDDB).withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('الموقع الرئيسي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 16),
                  label: const Text('خروج', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/admin/login'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Row 2: Navigation Tabs Horizontal Scroll Strip
  Widget _buildHeaderRow2(List<Map<String, dynamic>> tabs) {
    return GlassContainer(
      padding: const EdgeInsets.all(6),
      borderRadius: BorderRadius.circular(16),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final t = tabs[index];
            final isSelected = _activeTabIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => setState(() => _activeTabIndex = index),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF34211B) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFA0BDDB).withValues(alpha: 0.35)
                          : Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        t['icon'] as IconData,
                        size: 16,
                        color: isSelected ? const Color(0xFFF8F6F0) : const Color(0xFF34211B),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? const Color(0xFFF8F6F0) : const Color(0xFF34211B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // 1. Overview Tab
  Widget _buildOverviewTab() {
    final availableCount = _properties.length;
    final saleCount = _properties.where((p) => p.dealType == 'sale').length;
    final rentCount = _properties.where((p) => p.dealType == 'rent').length;
    final newInquiries = _inquiries.where((i) => i['status'] == 'جديد').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Responsive 4 Key Statistics Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isLarge = constraints.maxWidth > 850;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isLarge ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isLarge
                  ? 2.0
                  : (constraints.maxWidth > 480 ? 2.1 : 1.6),
              children: [
                _buildStatCard('إجمالي العقارات', '$availableCount', '$availableCount متاح في السجل', Icons.apartment_rounded, const Color(0xFF34211B)),
                _buildStatCard('عقارات للبيع', '$saleCount', '${((saleCount / availableCount) * 100).round()}% من المحفظة', Icons.sell_rounded, const Color(0xFFA0BDDB)),
                _buildStatCard('عقارات للإيجار', '$rentCount', '${((rentCount / availableCount) * 100).round()}% من المحفظة', Icons.key_rounded, const Color(0xFF34211B)),
                _buildStatCard('طلبات العملاء', '${_inquiries.length}', '$newInquiries طلبات جديدة', Icons.support_agent_rounded, AppColors.success),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        // Quick Actions Banner
        _buildQuickActionsBanner(),

        const SizedBox(height: 20),

        // Recent Inquiries & Regional Summary
        _buildRecentInquiriesCard(),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String badgeText, IconData icon, Color accent) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(18),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF34211B).withValues(alpha: 0.75),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF34211B),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badgeText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              color: const Color(0xFF34211B).withValues(alpha: 0.65),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsBanner() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إجراءات سريعة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
              ),
              SizedBox(height: 4),
              Text(
                'إدارة مباشرة وفورية للعقارات والطلبات المسجلة',
                style: TextStyle(fontSize: 12, color: Color(0x9934211B)),
              ),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34211B),
                  foregroundColor: const Color(0xFFF8F6F0),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('إضافة عقار جديد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () => setState(() => _activeTabIndex = 2),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF34211B),
                  side: BorderSide(color: const Color(0xFFA0BDDB).withValues(alpha: 0.6)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.table_chart_outlined, size: 16),
                label: const Text('جدول العقارات', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: () => setState(() => _activeTabIndex = 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentInquiriesCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'أحدث طلبات واستفسارات العملاء',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _activeTabIndex = 3),
                child: const Text('عرض الكل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF34211B))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._inquiries.take(3).map((inq) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFA0BDDB)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${inq['clientName']} — ${inq['propertyTitle']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF34211B)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    inq['date'] as String,
                    style: TextStyle(fontSize: 11, color: const Color(0xFF34211B).withValues(alpha: 0.6)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 2. Properties Management Table Tab
  Widget _buildPropertiesTableTab() {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _properties.where((p) {
      if (_filterDeal != 'all' && p.dealType != _filterDeal) return false;
      if (_filterGov != 'all' && p.governorate != _filterGov) return false;
      if (query.isNotEmpty) {
        return p.title.toLowerCase().contains(query) ||
            p.location.toLowerCase().contains(query) ||
            p.id.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search & Filters Header
        GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
          border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
          blurSigma: 16,
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'بحث بالعنوان أو الكود أو الموقع...',
                    prefixIcon: Icon(Icons.search, size: 18),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F6F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterDeal,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('كافة المعاملات', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'sale', child: Text('عقارات للبيع', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'rent', child: Text('عقارات للإيجار', style: TextStyle(fontSize: 12))),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _filterDeal = val);
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F6F0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterGov,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('كافة المحافظات', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'damascus', child: Text('دمشق', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'rif-damascus', child: Text('ريف دمشق', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'aleppo', child: Text('حلب', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'latakia', child: Text('اللاذقية', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'tartus', child: Text('طرطوس', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'homs', child: Text('حمص', style: TextStyle(fontSize: 12))),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _filterGov = val);
                        },
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34211B),
                      foregroundColor: const Color(0xFFF8F6F0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('إضافة عقار', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => setState(() => _activeTabIndex = 2),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Full Data Table Card
        GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
          border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
          blurSigma: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'قائمة العقارات (${filtered.length} عقار)',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                  ),
                  Text(
                    'تحديث مباشر • قاعدة بيانات موثقة',
                    style: TextStyle(fontSize: 11, color: const Color(0xFF34211B).withValues(alpha: 0.65)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const Divider(color: Color(0x33A0BDDB), height: 16),
                itemBuilder: (context, index) {
                  final prop = filtered[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 620;
                      if (isNarrow) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      color: AppColors.warmSand,
                                      child: Image.network(
                                        prop.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const Icon(
                                          Icons.apartment,
                                          size: 24,
                                          color: Color(0xFF34211B),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prop.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${prop.location} • ${prop.area}',
                                          style: TextStyle(fontSize: 11, color: const Color(0xFF34211B).withValues(alpha: 0.7)),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          prop.price,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF34211B)),
                                    label: const Text('تعديل', style: TextStyle(fontSize: 11, color: Color(0xFF34211B))),
                                    onPressed: () => _editProperty(prop),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                                    label: const Text('حذف', style: TextStyle(fontSize: 11, color: AppColors.error)),
                                    onPressed: () => _deleteProperty(prop),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF34211B)),
                                    label: const Text('معاينة', style: TextStyle(fontSize: 11, color: Color(0xFF34211B))),
                                    onPressed: () => Navigator.of(context).pushNamed('/properties/detail', arguments: prop),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: AppColors.warmSand,
                                child: Image.network(
                                  prop.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.apartment,
                                    size: 24,
                                    color: Color(0xFF34211B),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prop.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${prop.location} • ${prop.area}',
                                    style: TextStyle(fontSize: 11.5, color: const Color(0xFF34211B).withValues(alpha: 0.7)),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: prop.dealType == 'sale'
                                              ? const Color(0xFF34211B).withValues(alpha: 0.1)
                                              : const Color(0xFFA0BDDB).withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          prop.dealType == 'sale' ? 'للبيع' : 'للإيجار',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                        ),
                                      ),
                                      Text(
                                        prop.price,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Action Buttons: Edit, Delete, Preview
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF34211B)),
                                  tooltip: 'تعديل البيانات',
                                  onPressed: () => _editProperty(prop),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  tooltip: 'حذف العقار',
                                  onPressed: () => _deleteProperty(prop),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF34211B)),
                                  tooltip: 'معاينة في الموقع',
                                  onPressed: () => Navigator.of(context).pushNamed('/properties/detail', arguments: prop),
                                ),
                              ],
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
      ],
    );
  }

  // 3. Add Property Form Tab
  Widget _buildAddPropertyTab() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: Form(
        key: _addFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.add_business_outlined, size: 24, color: Color(0xFF34211B)),
                SizedBox(width: 8),
                Text(
                  'إضافة عقار جديد إلى المنصة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'أدخل المواصفات والبيانات الهندسية والقانونية للعقار ليتم تدقيقه ونشره فوراً.',
              style: TextStyle(fontSize: 12.5, color: const Color(0xFF34211B).withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 20),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان العقار التسويقي',
                hintText: 'مثال: شقة ديلوكس بإطلالة مفتوحة على حديقة الجاحظ في المالكي',
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'يرجى كتابة عنوان العقار' : null,
            ),
            const SizedBox(height: 14),

            // Governorate & Type & Deal (Responsive Wrap/Column)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 680;
                final govField = DropdownButtonFormField<String>(
                  initialValue: _addGov,
                  decoration: const InputDecoration(labelText: 'المحافظة'),
                  items: const [
                    DropdownMenuItem(value: 'damascus', child: Text('دمشق')),
                    DropdownMenuItem(value: 'rif-damascus', child: Text('ريف دمشق')),
                    DropdownMenuItem(value: 'aleppo', child: Text('حلب')),
                    DropdownMenuItem(value: 'latakia', child: Text('اللاذقية')),
                    DropdownMenuItem(value: 'tartus', child: Text('طرطوس')),
                    DropdownMenuItem(value: 'homs', child: Text('حمص')),
                  ],
                  onChanged: (v) => setState(() => _addGov = v ?? 'damascus'),
                );

                final typeField = DropdownButtonFormField<String>(
                  initialValue: _addType,
                  decoration: const InputDecoration(labelText: 'نوع العقار'),
                  items: const [
                    DropdownMenuItem(value: 'apartment', child: Text('شقة سكنية')),
                    DropdownMenuItem(value: 'villa', child: Text('فيلا / قصر')),
                    DropdownMenuItem(value: 'office', child: Text('مكتب تجاري')),
                    DropdownMenuItem(value: 'shop', child: Text('محل تجاري')),
                    DropdownMenuItem(value: 'land', child: Text('أرض / مزرعة')),
                  ],
                  onChanged: (v) => setState(() => _addType = v ?? 'apartment'),
                );

                final dealField = DropdownButtonFormField<String>(
                  initialValue: _addDeal,
                  decoration: const InputDecoration(labelText: 'المعاملة'),
                  items: const [
                    DropdownMenuItem(value: 'sale', child: Text('للبيع')),
                    DropdownMenuItem(value: 'rent', child: Text('للإيجار')),
                  ],
                  onChanged: (v) => setState(() => _addDeal = v ?? 'sale'),
                );

                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: govField),
                      const SizedBox(width: 10),
                      Expanded(child: typeField),
                      const SizedBox(width: 10),
                      Expanded(child: dealField),
                    ],
                  );
                }

                return Column(
                  children: [
                    govField,
                    const SizedBox(height: 12),
                    typeField,
                    const SizedBox(height: 12),
                    dealField,
                  ],
                );
              },
            ),

            const SizedBox(height: 14),

            // Price & Area (Responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 540;
                final priceField = TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'السعر (بالدولار الأمريكي)',
                    hintText: 'مثال: 450,000',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'يرجى كتابة السعر' : null,
                );

                final areaField = TextFormField(
                  controller: _areaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'المساحة (م²)',
                    hintText: 'مثال: 220',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'يرجى كتابة المساحة' : null,
                );

                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: priceField),
                      const SizedBox(width: 10),
                      Expanded(child: areaField),
                    ],
                  );
                }

                return Column(
                  children: [
                    priceField,
                    const SizedBox(height: 12),
                    areaField,
                  ],
                );
              },
            ),

            const SizedBox(height: 14),

            // Rooms & Bathrooms & Floor (Responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 640;
                final bedroomsField = TextFormField(
                  controller: _bedroomsController,
                  decoration: const InputDecoration(labelText: 'عدد الغرف'),
                );

                final bathroomsField = TextFormField(
                  controller: _bathroomsController,
                  decoration: const InputDecoration(labelText: 'عدد الحمامات'),
                );

                final floorField = TextFormField(
                  controller: _floorController,
                  decoration: const InputDecoration(labelText: 'الطابق'),
                );

                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: bedroomsField),
                      const SizedBox(width: 10),
                      Expanded(child: bathroomsField),
                      const SizedBox(width: 10),
                      Expanded(child: floorField),
                    ],
                  );
                }

                return Column(
                  children: [
                    bedroomsField,
                    const SizedBox(height: 12),
                    bathroomsField,
                    const SizedBox(height: 12),
                    floorField,
                  ],
                );
              },
            ),

            const SizedBox(height: 14),

            // Cadastral Status
            DropdownButtonFormField<String>(
              initialValue: _addCadastral,
              decoration: const InputDecoration(labelText: 'الوضع القانوني وسند الملكية'),
              items: const [
                DropdownMenuItem(
                  value: 'طابو أخضر نظامي 2400 سهم بريء الذمة',
                  child: Text('طابو أخضر نظامي 2400 سهم بريء الذمة'),
                ),
                DropdownMenuItem(
                  value: 'سجل مؤقت بريء الذمة قابل للفراغ',
                  child: Text('سجل مؤقت بريء الذمة قابل للفراغ'),
                ),
                DropdownMenuItem(
                  value: 'حكم محكمة قطعي مبرم ومسجل',
                  child: Text('حكم محكمة قطعي مبرم ومسجل'),
                ),
              ],
              onChanged: (v) => setState(() => _addCadastral = v ?? _addCadastral),
            ),
            const SizedBox(height: 14),

            // Image URL
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط الصورة الرئيسية للعقار',
                hintText: 'https://...',
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34211B),
                foregroundColor: const Color(0xFFF8F6F0),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.cloud_upload_outlined, size: 20),
              label: const Text('حفظ ونشر العقار الآن', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              onPressed: _saveNewProperty,
            ),
          ],
        ),
      ),
    );
  }

  // 4. Inquiries Tab
  Widget _buildInquiriesTab() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلبات المعاينة والاستفسارات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
              ),
              Icon(Icons.assignment, size: 20, color: Color(0xFF34211B)),
            ],
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _inquiries.length,
            separatorBuilder: (context, index) => const Divider(color: Color(0x33A0BDDB), height: 16),
            itemBuilder: (context, index) {
              final inq = _inquiries[index];
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 620;
                  if (isNarrow) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA0BDDB).withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.person, color: Color(0xFF34211B), size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inq['clientName'] as String,
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                    ),
                                    Text(
                                      inq['date'] as String,
                                      style: TextStyle(fontSize: 10, color: const Color(0xFF34211B).withValues(alpha: 0.55)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: inq['status'] == 'جديد'
                                      ? AppColors.warning.withValues(alpha: 0.2)
                                      : AppColors.success.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  inq['status'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: inq['status'] == 'جديد' ? AppColors.warning : AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${inq['type']} • ${inq['propertyTitle']}',
                            style: TextStyle(fontSize: 12, color: const Color(0xFF34211B).withValues(alpha: 0.75)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.chat, size: 16, color: Color(0xFF34211B)),
                                label: const Text('واتساب', style: TextStyle(fontSize: 11, color: Color(0xFF34211B))),
                                onPressed: () {
                                  final phone = (inq['phone'] as String).replaceAll(RegExp(r'[^\d+]'), '');
                                  launchUrl(
                                    Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent("مرحباً ${inq['clientName']}، بخصوص طلبكم على منصة Axion Digital.")}'),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.phone, size: 16, color: Color(0xFF34211B)),
                                label: const Text('اتصال', style: TextStyle(fontSize: 11, color: Color(0xFF34211B))),
                                onPressed: () {
                                  final phone = (inq['phone'] as String).replaceAll(' ', '');
                                  launchUrl(Uri.parse('tel:$phone'));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA0BDDB).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person, color: Color(0xFF34211B), size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  inq['clientName'] as String,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: inq['status'] == 'جديد'
                                        ? AppColors.warning.withValues(alpha: 0.2)
                                        : AppColors.success.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    inq['status'] as String,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: inq['status'] == 'جديد' ? AppColors.warning : AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${inq['type']} • ${inq['propertyTitle']}',
                              style: TextStyle(fontSize: 12, color: const Color(0xFF34211B).withValues(alpha: 0.75)),
                            ),
                            Text(
                              inq['date'] as String,
                              style: TextStyle(fontSize: 10.5, color: const Color(0xFF34211B).withValues(alpha: 0.55)),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat, size: 18, color: Color(0xFF34211B)),
                            tooltip: 'واتساب',
                            onPressed: () {
                              final phone = (inq['phone'] as String).replaceAll(RegExp(r'[^\d+]'), '');
                              launchUrl(
                                Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent("مرحباً ${inq['clientName']}، بخصوص طلبكم على منصة Axion Digital.")}'),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone, size: 18, color: Color(0xFF34211B)),
                            tooltip: 'اتصال',
                            onPressed: () {
                              final phone = (inq['phone'] as String).replaceAll(' ', '');
                              launchUrl(Uri.parse('tel:$phone'));
                            },
                          ),
                        ],
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

  // 5. Analytics Tab
  Widget _buildAnalyticsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(22),
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
          border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
          blurSigma: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'توزيع المحفظة العقارية جغرافياً في سوريا',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
              ),
              const SizedBox(height: 16),
              ...MockData.governorates.map((g) {
                final pct = (g.propertyCount / 184).clamp(0.0, 1.0);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(g.nameAr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF34211B))),
                          Text('${g.propertyCount} عقار (${(pct * 100).round()}%)', style: TextStyle(fontSize: 12, color: const Color(0xFF34211B).withValues(alpha: 0.75))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          backgroundColor: AppColors.warmSand,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34211B)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // 6. Settings Tab
  Widget _buildSettingsTab() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(22),
      color: const Color(0xFFF8F6F0).withValues(alpha: 0.75),
      border: Border.all(color: const Color(0xFFA0BDDB).withValues(alpha: 0.35), width: 1.0),
      blurSigma: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'إعدادات وهوية المنصة (${_settings.companyNameAr})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF34211B)),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final nameArField = TextField(
                controller: _companyNameArController,
                decoration: const InputDecoration(labelText: 'اسم الشركة (عربي)'),
              );
              final nameEnField = TextField(
                controller: _companyNameEnController,
                decoration: const InputDecoration(labelText: 'اسم الشركة (إنجليزي)'),
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: nameArField),
                    const SizedBox(width: 10),
                    Expanded(child: nameEnField),
                  ],
                );
              }

              return Column(
                children: [
                  nameArField,
                  const SizedBox(height: 12),
                  nameEnField,
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final phoneField = TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف الرسمي'),
              );
              final whatsappField = TextField(
                controller: _whatsappController,
                decoration: const InputDecoration(labelText: 'رقم الواتساب المعتمد'),
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: phoneField),
                    const SizedBox(width: 10),
                    Expanded(child: whatsappField),
                  ],
                );
              }

              return Column(
                children: [
                  phoneField,
                  const SizedBox(height: 12),
                  whatsappField,
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'البريد الإلكتروني للإدارة'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'العنوان والمقر الرئيسي'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'الوصف التعريفي المختصر'),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34211B),
              foregroundColor: const Color(0xFFF8F6F0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _saveSettings,
            child: const Text('حفظ وتحديث الإعدادات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
