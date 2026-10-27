class District {
  final String id;
  final String nameAr;
  final String? governorateId;

  const District({
    required this.id,
    required this.nameAr,
    this.governorateId,
  });
}

class Governorate {
  final String id;
  final String nameAr;
  final int propertyCount;
  final String? image;
  final List<District> districts;

  const Governorate({
    required this.id,
    required this.nameAr,
    required this.propertyCount,
    this.image,
    required this.districts,
  });
}
