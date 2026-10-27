class CompanySettings {
  final String companyNameAr;
  final String companyNameEn;
  final String address;
  final String phone;
  final String whatsapp;
  final String email;
  final String shortDescription;

  const CompanySettings({
    required this.companyNameAr,
    required this.companyNameEn,
    required this.address,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.shortDescription,
  });

  static const defaultSettings = CompanySettings(
    companyNameAr: 'Axion Digital العقارية',
    companyNameEn: 'Axion Digital Real Estate',
    address: 'دمشق، حي المالكي — شارع عبد المنعم رياض، بناء رقم 12',
    phone: '+963 11 334 5678',
    whatsapp: '+963 944 123 456',
    email: 'info@axiondigital.sy',
    shortDescription:
        'البوابة العقارية الرقمية الأولى والرائدة في الجمهورية العربية السورية لتوثيق وتسويق أرقى العقارات للبيع والإيجار.',
  );
}
