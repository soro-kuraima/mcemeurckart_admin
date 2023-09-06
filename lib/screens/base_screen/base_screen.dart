import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    const AddUser(),
    const Users(),
    const RequestedUsers(),
    const Generics(),
    const AddGenerics(),
    const AddCategory(),
    const Categories(),
    const AddProduct(),
    const Products(),
    const Orders(),
    const GenerateReports(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text('mcemeurckart Admin'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          drawer: CustomDrawer(
            controller: pageController,
          ),
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: screens,
          )),
    );
  }
}
