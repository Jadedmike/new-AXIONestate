import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/property.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/property_card.dart';
import '../widgets/search_filters_bar.dart';

class PropertiesScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const PropertiesScreen({super.key, this.initialFilters});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _deal = 'all';
  String _gov = 'all';
  String _type = 'all';
  String _sortBy = 'newest';

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _deal = widget.initialFilters!['deal'] ?? 'all';
      _gov = widget.initialFilters!['gov'] ?? 'all';
      _type = widget.initialFilters!['type'] ?? 'all';
    }
  }

  List<Property> get _filteredProperties {
    return MockData.properties.where((p) {
      if (_deal != 'all' && p.dealType != _deal) return false;
      if (_gov != 'all' && p.governorate != _gov) return false;
      if (_type != 'all' && p.propertyType != _type) return false;
      return true;
    }).toList()
      ..sort((a, b) {
        if (_sortBy == 'price_asc') {
          return a.priceNumeric.compareTo(b.priceNumeric);
        } else if (_sortBy == 'price_desc') {
          return b.priceNumeric.compareTo(a.priceNumeric);
        }
        return 0; // default newest
      });
  }

  void _resetFilters() {
    setState(() {
      _deal = 'all';
      _gov = 'all';
      _type = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final properties = _filteredProperties;

    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      endDrawerEnableOpenDragGesture: true,
      drawer: const AppDrawer(currentRoute: '/properties', isEndDrawer: false),
      endDrawer: const AppDrawer(currentRoute: '/properties', isEndDrawer: true),
      appBar: AppHeader(
        currentRoute: '/properties',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              color: AppColors.mochaBrown,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1152),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'سجل العقارات المتاحة للبيع والإيجار',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warmIvory,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'عقارات مدققة وموثقة قانونياً في مختلف المحافظات والمناطق السورية',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.warmIvory.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Top Search Filter Bar
            Transform.translate(
              offset: const Offset(0, -20),
              child: SearchFiltersBar(
                initialDeal: _deal != 'all' ? _deal : null,
                initialGov: _gov != 'all' ? _gov : null,
                initialType: _type != 'all' ? _type : null,
                onSearch: (filters) {
                  setState(() {
                    _deal = filters['deal'] ?? 'all';
                    _gov = filters['gov'] ?? 'all';
                    _type = filters['type'] ?? 'all';
                  });
                },
              ),
            ),

            // Main Catalog Content
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1152),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Deal Type Filter Chips & Sort
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          // Deal Tabs
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildDealChip('الكل', 'all'),
                              const SizedBox(width: 6),
                              _buildDealChip('عقارات للبيع', 'sale'),
                              const SizedBox(width: 6),
                              _buildDealChip('عقارات للإيجار', 'rent'),
                            ],
                          ),

                          // Sort Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.warmIvory.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.iceBlue.withValues(alpha: 0.35),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _sortBy,
                                icon: const Icon(Icons.sort, size: 18, color: AppColors.mochaBrown),
                                items: const [
                                  DropdownMenuItem(value: 'newest', child: Text('الأحدث إضافةً', style: TextStyle(fontSize: 12))),
                                  DropdownMenuItem(value: 'price_asc', child: Text('السعر: من الأقل للأعلى', style: TextStyle(fontSize: 12))),
                                  DropdownMenuItem(value: 'price_desc', child: Text('السعر: من الأعلى للأقل', style: TextStyle(fontSize: 12))),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _sortBy = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Results Count & Active Filters Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تم العثور على ${properties.length} عقار متاح',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mochaBrown.withValues(alpha: 0.85),
                            ),
                          ),
                          if (_deal != 'all' || _gov != 'all' || _type != 'all')
                            TextButton.icon(
                              onPressed: _resetFilters,
                              icon: const Icon(Icons.refresh, size: 16, color: AppColors.mochaBrown),
                              label: const Text(
                                'إعادة ضبط الفلاتر',
                                style: TextStyle(fontSize: 12, color: AppColors.mochaBrown, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Properties Grid
                      if (properties.isNotEmpty)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            int count = 1;
                            double childAspectRatio = 1.15;

                            if (constraints.maxWidth >= 960) {
                              count = 3;
                              childAspectRatio = 1.02;
                            } else if (constraints.maxWidth >= 600) {
                              count = 2;
                              childAspectRatio = 1.05;
                            } else {
                              count = 1;
                              childAspectRatio = 1.18;
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: properties.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: count,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemBuilder: (context, index) {
                                return PropertyCard(property: properties[index]);
                              },
                            );
                          },
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(48),
                          decoration: BoxDecoration(
                            color: AppColors.warmIvory.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 56,
                                color: AppColors.mochaBrown.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'لا توجد عقارات مطابقة لمعايير البحث الحالية',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mochaBrown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'جرب تغيير المحافظة أو النوع أو توسيع نطاق السعر.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mochaBrown.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _resetFilters,
                                child: const Text('عرض جميع العقارات'),
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

            // Persistent Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDealChip(String label, String value) {
    final isSelected = _deal == value;
    return GestureDetector(
      onTap: () => setState(() => _deal = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mochaBrown : AppColors.warmSand.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.iceBlue.withValues(alpha: 0.4) : AppColors.iceBlue.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppColors.warmIvory : AppColors.mochaBrown,
          ),
        ),
      ),
    );
  }
}
