class PromoCodeModal {
  final double promoCodeDiscount;
  final String promoCodeName;
  final String promoCodeId;

  PromoCodeModal({
    required this.promoCodeDiscount,
    required this.promoCodeName,
    required this.promoCodeId,
  });

  factory PromoCodeModal.fromMap(Map<String, dynamic> map) {
    return PromoCodeModal(
      promoCodeDiscount: map['discount'],
      promoCodeName: map['name'],
      promoCodeId: map['id'],
    );
  }
}