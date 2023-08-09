class ProductModel {
  String? code;
  String? nama;
  String? productId;
  int? qty;

  ProductModel({
    this.code,
    this.nama,
    this.productId,
    this.qty,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        nama: json["nama"] ?? "",
        productId: json["productId"] ?? "",
        qty: json["qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "nama": nama,
        "productId": productId,
        "qty": qty,
      };
}
