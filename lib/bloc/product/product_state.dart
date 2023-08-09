part of 'product_bloc.dart';

abstract class ProductState {}

//state -> kondisi product
//1. product awal -> masih kosong
//2. product loading
//3. product completed -> ketika berhasil mendapatkan data dari db
//4. product error -> ggl dapat data dr db

class ProductStateInitial extends ProductState {}

class ProductStateLoadingExport extends ProductState {}

class ProductStateLoadingAdd extends ProductState {}

class ProductStateLoadingEdit extends ProductState {}

class ProductStateLoadingDelete extends ProductState {}

class ProductStateCompleteAdd extends ProductState {}

class ProductStateCompleteEdit extends ProductState {}

class ProductStateCompleteDelete extends ProductState {}

class ProductStateCompleteExport extends ProductState {}

class ProductStateError extends ProductState {
  ProductStateError(this.message);

  String message;
}
