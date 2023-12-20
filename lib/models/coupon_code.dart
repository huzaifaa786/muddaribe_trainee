class CouponCode {
  final String id;
  final String code;
  final String percentage;

  CouponCode({
    required this.id,
    required this.code,
    required this.percentage,
  });

  factory CouponCode.fromMap(Map<String, dynamic> map) {
    return CouponCode(
      id: map['id'],
      code: map['CouponCode'],
      percentage: map['DiscountPercentage'],
    );
  }
}
