part of 'product_bloc.dart';

abstract class ProductEvent {}

//tindakan
//1. tambah product
//2. edit product
//3. hapus product

class ProductEventAddProduct extends ProductEvent {
  ProductEventAddProduct(
      {required this.code, required this.nama, required this.qty});

  final String code;
  final String nama;
  final int qty;
}

class ProductEventEditProduct extends ProductEvent {
  ProductEventEditProduct(
      {required this.id, required this.nama, required this.qty});

  final String id;
  final String nama;
  final int qty;
}

class ProductEventDeleteProduct extends ProductEvent {
  ProductEventDeleteProduct(this.id);

  final String id;
}

class ProductEventExportPdf extends ProductEvent {}
