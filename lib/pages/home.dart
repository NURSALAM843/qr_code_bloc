import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_bloc/bloc/bloc.dart';
import 'package:qr_code_bloc/routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: const [],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthStateLogout) {
          context.goNamed(Routes.login);
        }
      }, builder: (context, state) {
        if (state is AuthStateLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0,
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: 4,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Add Products";
                icon = Icons.post_add_rounded;
                onTap = () => context.goNamed(Routes.addProducts);
                break;
              case 1:
                title = "Products";
                icon = Icons.list_alt_outlined;
                onTap = () => context.goNamed(Routes.products);
                break;
              case 2:
                title = "QR Code";
                icon = Icons.qr_code_2_outlined;
                onTap = () async {};
                break;
              case 3:
                title = "Catalog";
                icon = Icons.document_scanner_outlined;
                onTap = () {
                  context.read<ProductBloc>().add(ProductEventExportPdf());
                };
                break;
            }
            return Material(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                borderRadius: BorderRadius.circular(9),
                onTap: onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (index == 3)
                        ? BlocConsumer<ProductBloc, ProductState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              if (state is ProductStateLoadingExport) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  icon,
                                  size: 50,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 50,
                            width: 50,
                            child: Icon(
                              icon,
                              size: 50,
                            ),
                          ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(title)
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
