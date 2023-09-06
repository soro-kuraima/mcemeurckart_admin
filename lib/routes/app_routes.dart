import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:mcemeurckart_admin/screens/add_generics/add_generics.dart";
import "package:mcemeurckart_admin/screens/add_product/add_product.dart";
import "package:mcemeurckart_admin/screens/add_user/add_user.dart";
import "package:mcemeurckart_admin/screens/auth_screen/signin_screen.dart";
import "package:mcemeurckart_admin/screens/base_screen/base_screen.dart";
import "package:mcemeurckart_admin/screens/categories/categories.dart";
import "package:mcemeurckart_admin/screens/edit_user/edit_user.dart";
import "package:mcemeurckart_admin/screens/generics/generics.dart";
import "package:mcemeurckart_admin/screens/home_screen/home_screen.dart";
import "package:mcemeurckart_admin/screens/product/product.dart";
import "package:mcemeurckart_admin/screens/products/products.dart";
import "package:mcemeurckart_admin/screens/requested_user/requested_user.dart";
import "package:mcemeurckart_admin/screens/requested_users/requested_users.dart";
import "package:mcemeurckart_admin/screens/users/users.dart";
import "package:mcemeurckart_admin/screens/user/user.dart";
import "package:mcemeurckart_admin/screens/orders/orders.dart";
import "package:mcemeurckart_admin/screens/order/order.dart";
import "package:mcemeurckart_admin/screens/generate_reports/generate_reports.dart";
import 'package:mcemeurckart_admin/screens/view_category/view_category.dart';
import "package:mcemeurckart_admin/screens/add_category/add_category.dart";

abstract class AppPages {
  static const initial = AppRoutes.baseRoute;

  static final pages = <GetPage>[
    /* 
    * ===== Auth Pages =====
     */
    GetPage(
      name: AppRoutes.signInRoute,
      page: () => const SignInScreen(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.baseRoute,
      page: () => const BaseScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    /* 
    * ===== Home Page =====
     */
    GetPage(
      name: AppRoutes.homeRoute,
      page: () => const HomeScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    /* 
    * ===== User Management =====
     */
    GetPage(
      name: AppRoutes.users,
      page: () => const Users(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.user,
      page: () => const User(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.addUser,
      page: () => const AddUser(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.editUser,
      page: () => const EditUser(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.requestedUsers,
      page: () => const RequestedUsers(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.requestedUser,
      page: () => const RequestedUser(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.downToUp,
    ),

    /* ==== to create and view generics ======  */
    GetPage(
      name: AppRoutes.generics,
      page: () => const Generics(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addGenerics,
      page: () => const AddGenerics(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),

    /* ==== to create and view generics ====== */
    GetPage(
      name: AppRoutes.categories,
      page: () => const Categories(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.category,
      page: () => const ViewCategory(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addCategory,
      page: () => const AddCategory(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),

    /* ==== to view and add products ====== */

    GetPage(
      name: AppRoutes.products,
      page: () => const Products(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.product,
      page: () => const Product(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddProduct(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),

    /* ==== to view and manage orders ====== */
    GetPage(
      name: AppRoutes.orders,
      page: () => const Orders(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.order,
      page: () => const Order(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.generateReports,
      page: () => const GenerateReports(),
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      transition: Transition.rightToLeft,
    ),
  ];
}

abstract class AppRoutes {
  static const signInRoute = '/sign-in';

  static const baseRoute = '/';

  static const homeRoute = '/home';

  static const users = '/users';

  static const user = '/user';

  static const addUser = '/add-user';

  static const editUser = '/edit-user';

  static const requestedUsers = '/requested-users';

  static const requestedUser = '/requested-user';

  static const generics = '/generics';

  static const addGenerics = '/add-generics';

  static const categories = '/categories';

  static const category = '/category';

  static const addCategory = '/add-category';

  static const orders = '/orders';

  static const order = '/order';

  static const generateReports = '/generate-reports';

  static const products = '/products';

  static const product = '/product';

  static const addProduct = '/add-product';
}
