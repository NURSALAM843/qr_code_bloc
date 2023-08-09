import 'package:go_router/go_router.dart';
import 'package:qr_code_bloc/models/product_model.dart';
import 'package:qr_code_bloc/pages/add_product.dart';
import 'package:qr_code_bloc/pages/detail_products.dart';
import 'package:qr_code_bloc/pages/error.dart';
import 'package:qr_code_bloc/pages/login.dart';
import 'package:qr_code_bloc/pages/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/home.dart';
part 'router_name.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (context, state) {
    //cek kondisi auth-> login atau tidak
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      //tidak sedang login
      return "/login";
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    //KALAU 1 Level -> push replacement
    //KALAU sub Level -> push biasa
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: 'add-products',
          name: Routes.addProducts,
          builder: (context, state) => AddProductPage(),
        ),
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => ProductPage(),
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.detailProducts,
              builder: (context, state) => DetailProductPage(
                state.params['productId'].toString(),
                state.extra as ProductModel,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
