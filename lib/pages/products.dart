import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_bloc/bloc/bloc.dart';
import 'package:qr_code_bloc/routes/router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/product_model.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productB = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        actions: const [],
      ),
      body: StreamBuilder<QuerySnapshot<ProductModel>>(
        stream: productB.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text("Tidak Ada Data"),
            );
          }

          //Looping Data
          List<ProductModel> allProducts = [];
          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
          }

          if (allProducts.isEmpty) {
            return const Center(
              child: Text("Tidak Ada Data"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: allProducts.length,
            itemBuilder: (context, index) {
              ProductModel product = allProducts[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                child: InkWell(
                  onTap: () {
                    context.goNamed(
                      Routes.detailProducts,
                      params: {
                        "productId": product.productId!,
                      },
                      extra: product,
                    );
                  },
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(product.nama!),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text("Jumlah : ${product.qty}"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code!,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
