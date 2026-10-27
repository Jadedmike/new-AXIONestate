import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_data.dart';
import '../models/location.dart';
import 'glass_container.dart';

class SearchFiltersBar extends StatefulWidget {
  final String? initialDeal;
  final String? initialGov;
  final String? initialDistrict;
  final String? initialType;
  final Function(Map<String, dynamic> filters)? onSearch;

  const SearchFiltersBar({
    super.key,
    this.initialDeal,
    this.initialGov,
    this.initialDistrict,
    this.initialType,
    this.onSearch,
  });

  @override
  State<SearchFiltersBar> createState() => _SearchFiltersBarState();
}

class _SearchFiltersBarState extends State<SearchFiltersBar> {
  late String _dealType;
  late String _selectedGovId;
  late String _selectedDistrictId;
  late String _selectedType;
  String _selectedBedrooms = 'all';
  String _priceCategory = 'متوسط راقٍ';
  bool _isSearching = false;

  final Map<String, String> _priceLabels = {
    'اقتصادي': '\$20,000 - \$80,000',
    'متوسط راقٍ': '\$80,000 - \$250,000',
    'VIP فاخر': '\$250,000 - \$1,500,000+',
  };

  @override
  void initState() {
    super.initState();
    _dealType = widget.initialDeal ?? 'sale';
    _selectedGovId = widget.initialGov ?? MockData.governorates.first.id;
    _selectedDistrictId = widget.initialDistrict ?? 'all';
    _selectedType = widget.initialType ?? 'all';
  }

  Governorate? get _currentGovernorate {
    try {
      return MockData.governorates.firstWhere((g) => g.id == _selectedGovId);
    } catch (_) {
      return MockData.governorates.first;
    }
  }

  List<District> get _currentDistricts {
    final gov = _currentGovernorate;
    return gov?.districts ?? [];
  }

  void _executeSearch() async {
    setState(() => _isSearching = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _isSearching = false);
      final filters = {
        'deal': _dealType,
        'gov': _selectedGovId,
        'district': _selectedDistrictId,
        'type': _selectedType,
        'bedrooms': _selectedBedrooms,
        'priceCategory': _priceCategory,
      };

      if (widget.onSearch != null) {
        widget.onSearch!(filters);
      } else {
        Navigator.of(context).pushNamed('/properties', arguments: filters);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1152), // Strictly constrained
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GlassContainer(
            padding: const EdgeInsets.all(22),
            borderRadius: BorderRadius.circular(24),
            color: AppColors.warmIvory.withValues(alpha: 0.85),
            border: Border.all(
              color: AppColors.iceBlue.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.mochaBrown.withValues(alpha: 0.10),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Deal Type Tabs (للبيع / للإيجار)
                Center(
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.warmSand.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.iceBlue.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDealTab(
                            label: 'عقارات للبيع',
                            icon: Icons.sell,
                            isSelected: _dealType == 'sale',
                            onTap: () => setState(() => _dealType = 'sale'),
                          ),
                        ),
                        Expanded(
                          child: _buildDealTab(
                            label: 'عقارات للإيجار',
                            icon: Icons.key,
                            isSelected: _dealType == 'rent',
                            onTap: () => setState(() => _dealType = 'rent'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Responsive Grid: 4 columns on desktop, 1 or 2 on mobile
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    if (width >= 850) {
                      // 4 Columns Desktop
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildGovernorateSelector()),
                          const SizedBox(width: 14),
                          Expanded(child: _buildDistrictSelector()),
                          const SizedBox(width: 14),
                          Expanded(child: _buildTypeSelector()),
                          const SizedBox(width: 14),
                          Expanded(child: _buildPriceRangeSelector()),
                        ],
                      );
                    } else if (width >= 550) {
                      // 2x2 Grid Tablet
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildGovernorateSelector()),
                              const SizedBox(width: 14),
                              Expanded(child: _buildDistrictSelector()),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(child: _buildTypeSelector()),
                              const SizedBox(width: 14),
                              Expanded(child: _buildPriceRangeSelector()),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // 1 Column Mobile
                      return Column(
                        children: [
                          _buildGovernorateSelector(),
                          const SizedBox(height: 12),
                          _buildDistrictSelector(),
                          const SizedBox(height: 12),
                          _buildTypeSelector(),
                          const SizedBox(height: 12),
                          _buildPriceRangeSelector(),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 18),

                // Execute Search CTA Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mochaBrown,
                    foregroundColor: AppColors.warmIvory,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: AppColors.mochaBrown.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.iceBlue.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                  onPressed: _isSearching ? null : _executeSearch,
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.warmIvory,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'بحث فوري عن العقارات المتاحة',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDealTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mochaBrown : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.iceBlue.withValues(alpha: 0.4) : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.mochaBrown.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.warmIvory : AppColors.mochaBrown.withValues(alpha: 0.75),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.warmIvory : AppColors.mochaBrown.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovernorateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_city, size: 16, color: AppColors.mochaBrown),
            const SizedBox(width: 6),
            Text(
              'المحافظة',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.mochaBrown.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.warmIvory.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedGovId,
              icon: const Icon(Icons.expand_more, size: 20, color: AppColors.mochaBrown),
              items: MockData.governorates.map((g) {
                return DropdownMenuItem<String>(
                  value: g.id,
                  child: Text(
                    g.nameAr,
                    style: const TextStyle(fontSize: 13, color: AppColors.mochaBrown),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedGovId = val;
                    _selectedDistrictId = 'all';
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistrictSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.map, size: 16, color: AppColors.mochaBrown),
            const SizedBox(width: 6),
            Text(
              'المنطقة أو الحي',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.mochaBrown.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.warmIvory.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDistrictId,
              icon: const Icon(Icons.expand_more, size: 20, color: AppColors.mochaBrown),
              items: _currentDistricts.map((d) {
                return DropdownMenuItem<String>(
                  value: d.id,
                  child: Text(
                    d.nameAr,
                    style: const TextStyle(fontSize: 13, color: AppColors.mochaBrown),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedDistrictId = val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.apartment, size: 16, color: AppColors.mochaBrown),
                const SizedBox(width: 6),
                Text(
                  'النوع',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mochaBrown.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            Text(
              _selectedBedrooms != 'all' ? '$_selectedBedrooms غرف' : 'كل الغرف',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.mochaBrown.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.warmIvory.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedType,
                    icon: const Icon(Icons.expand_more, size: 18, color: AppColors.mochaBrown),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('الكل', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'apartment', child: Text('شقق', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'villa', child: Text('فلل', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'office', child: Text('مكاتب', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'shop', child: Text('محلات', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'land', child: Text('أراضٍ', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.warmIvory.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.iceBlue.withValues(alpha: 0.35)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedBedrooms,
                    icon: const Icon(Icons.expand_more, size: 18, color: AppColors.mochaBrown),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('الغرف', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: '1', child: Text('1 نوم', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: '2', child: Text('2 نوم', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: '3', child: Text('3 نوم', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: '4', child: Text('4 نوم', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: '5+', child: Text('5+ نوم', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedBedrooms = val);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 16, color: AppColors.mochaBrown),
                const SizedBox(width: 6),
                Text(
                  'نطاق السعر',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mochaBrown.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Text(
                _priceLabels[_priceCategory] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mochaBrown,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: ['اقتصادي', 'متوسط راقٍ', 'VIP فاخر'].map((cat) {
            final isSelected = _priceCategory == cat;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _priceCategory = cat),
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.mochaBrown : AppColors.warmIvory.withValues(alpha: 0.70),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.iceBlue.withValues(alpha: 0.40)
                          : AppColors.iceBlue.withValues(alpha: 0.30),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.mochaBrown.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    cat,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.warmIvory : AppColors.mochaBrown,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
