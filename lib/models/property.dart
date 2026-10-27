class PropertyImage {
  final String url;
  final String alt;
  final String? label;

  const PropertyImage({
    required this.url,
    required this.alt,
    this.label,
  });
}

class PropertySpec {
  final String label;
  final String value;
  final String icon;

  const PropertySpec({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class Property {
  final String id;
  final String title;
  final String location;
  final String governorate;
  final String district;
  final String dealType; // 'sale' | 'rent'
  final String propertyType; // 'apartment' | 'villa' | 'office' | 'shop' | 'land'
  final String price;
  final double priceNumeric;
  final String? priceNote;
  final bool isNegotiable;
  final List<String> badges;
  final String? badgeHighlight;
  final String area;
  final String bedrooms;
  final String bathrooms;
  final String? floor;
  final String publishedTime;
  final String? cadastralStatus;
  final String? paymentTerms;
  final String imageUrl;
  final String imageAlt;
  final List<PropertyImage> images;
  final List<PropertySpec> specs;
  final List<String> features;
  final bool isFeatured;
  final bool isOffer;

  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.governorate,
    required this.district,
    required this.dealType,
    required this.propertyType,
    required this.price,
    required this.priceNumeric,
    this.priceNote,
    this.isNegotiable = false,
    required this.badges,
    this.badgeHighlight,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    this.floor,
    required this.publishedTime,
    this.cadastralStatus,
    this.paymentTerms,
    required this.imageUrl,
    required this.imageAlt,
    this.images = const [],
    this.specs = const [],
    this.features = const [],
    this.isFeatured = false,
    this.isOffer = false,
  });
}
