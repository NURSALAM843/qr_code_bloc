import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_bloc/bloc/bloc.dart';
import 'package:qr_code_bloc/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailProductPage extends StatelessWidget {
  DetailProductPage(this.id, this.product, {super.key});

  final String id;

  final ProductModel product;

  final TextEditingController codeC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    codeC.text = product.code!;
    namaC.text = product.nama!;
    qtyC.text = product.qty.toString()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Product"),
        actions: const [],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code!,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            readOnly: true,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            autocorrect: false,
            controller: namaC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Qty",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (codeC.text.isEmpty &&
                  namaC.text.isEmpty &&
                  qtyC.text.isEmpty) {
                //snackbar error
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Wajib Mengisi Semua Data"),
                  duration: Duration(seconds: 2),
                ));
              } else {
                context.read<ProductBloc>().add(
                      ProductEventEditProduct(
                        nama: namaC.text,
                        qty: int.tryParse(qtyC.text) ?? 0,
                        id: product.productId!,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 2),
                  ));
                }
                if (state is ProductStateCompleteEdit) {
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingEdit
                      ? "Loading..."
                      : "Update Product",
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(ProductEventDeleteProduct(product.productId!));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    duration: const Duration(seconds: 2),
                  ));
                }
                if (state is ProductStateCompleteDelete) {
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingDelete
                      ? "Loading..."
                      : "Delete Product",
                  style: TextStyle(
                    color: Colors.red[700],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
