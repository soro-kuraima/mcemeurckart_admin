import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/categories_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/generics_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/orders_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/products_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/users_controller_getx.dart';

import 'package:mcemeurckart_admin/screens/home_screen/home_screen.dart';

import 'widgets/custom_drawer.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final pageController = PageController();

  final screens = [
    HomeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    Get.put(GenericsController());
    Get.put(CategoriesController());
    Get.put(ProductsController());
    Get.put(OrdersController());
    Get.put(UsersController());

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.blue100,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          drawer: CustomDrawer(),
          body: GetBuilder<GenericsController>(
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
