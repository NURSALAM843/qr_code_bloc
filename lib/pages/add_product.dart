import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_bloc/bloc/bloc.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final TextEditingController codeC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: codeC,
            autocorrect: false,
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Code Product",
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: namaC,
            autocorrect: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name Product",
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: qtyC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Qty Product",
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
              } else if (codeC.text.length < 10) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Wajib Mengisi Code Product 10 Karakter"),
                  duration: Duration(seconds: 2),
                ));
              } else {
                context.read<ProductBloc>().add(
                      ProductEventAddProduct(
                        code: codeC.text,
                        nama: namaC.text,
                        qty: int.tryParse(qtyC.text) ?? 0,
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
                if (state is ProductStateCompleteAdd) {
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  state is ProductStateLoadingAdd
                      ? "Loading..."
                      : "Add Product",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
