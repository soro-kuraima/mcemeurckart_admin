import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/categories_controller.dart';
import 'package:mcemeurckart_admin/controller/generics_controller.dart';
import 'package:mcemeurckart_admin/screens/add_category/add_category.dart';
import 'package:mcemeurckart_admin/screens/add_generics/add_generics.dart';
import 'package:mcemeurckart_admin/screens/add_product/add_product.dart';
import 'package:mcemeurckart_admin/screens/add_user/add_user.dart';
import 'package:mcemeurckart_admin/screens/categories/categories.dart';
import 'package:mcemeurckart_admin/screens/edit_user/edit_user.dart';
import 'package:mcemeurckart_admin/screens/generate_reports/generate_reports.dart';
import 'package:mcemeurckart_admin/screens/generics/generics.dart';
import 'package:mcemeurckart_admin/screens/home_screen/home_screen.dart';
import 'package:mcemeurckart_admin/screens/order/order.dart';
import 'package:mcemeurckart_admin/screens/orders/orders.dart';
import 'package:mcemeurckart_admin/screens/product/product.dart';
import 'package:mcemeurckart_admin/screens/products/products.dart';
import 'package:mcemeurckart_admin/screens/requested_user/requested_user.dart';
import 'package:mcemeurckart_admin/screens/requested_users/requested_users.dart';
import 'package:mcemeurckart_admin/screens/user/user.dart';
import 'package:mcemeurckart_admin/screens/users/users.dart';
import 'package:mcemeurckart_admin/screens/view_category/view_category.dart';

import 'widgets/custom_drawer.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final pageController = PageController();

  final screens = [
    const HomeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: GetBuilder<GenericsController>(
        builder: (genericsController) {
          return GetBuilder<CategoriesController>(
            builder: (categoriesController) {
              return PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: screens,
              );
            },
          );
        },
      )),
    );
  }
}
