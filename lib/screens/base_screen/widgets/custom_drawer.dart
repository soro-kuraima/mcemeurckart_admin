import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/app_colors.dart';
import 'package:mcemeurckart_admin/controller/categories_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50.0,
              ),

              //User Information.
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 50.0,
                      child: Image.asset(
                        'assets/images/dummyImage.png',
                      ),
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: AppColors.neutral900,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              leading: Icon(
                Icons.person,
                color: AppColors.red300,
              ),
              title: const Text('Manage Users'),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40.0),
                  title: const Text('View Users'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Get.toNamed(AppRoutes.users);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40.0),
                  title: const Text('Requested Users'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Get.toNamed(AppRoutes.requestedUsers);
                  },
                ),
              ],
            ),
            ExpansionTile(
                title: const Text('Generics'),
                leading: Icon(
                  Icons.local_activity,
                  color: AppColors.red300,
                ),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('View Generics'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.generics);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Add Generic'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.addGenerics);
                    },
                  ),
                ]),
            ExpansionTile(
                title: const Text('Categories'),
                leading: Icon(
                  Icons.category,
                  color: AppColors.red300,
                ),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Add Category'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.addCategory);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('View Categories'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.rootCategories);
                    },
                  ),
                ]),
            ExpansionTile(
                title: const Text('Products'),
                leading: Icon(
                  Icons.local_offer,
                  color: AppColors.red300,
                ),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Add Product'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.addProduct);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Products'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.products);
                    },
                  ),
                ]),
            ExpansionTile(
                title: const Text('Orders'),
                leading: Icon(
                  Icons.shopping_bag,
                  color: AppColors.red300,
                ),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Orders'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.orders);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Generate Reports'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Get.toNamed(AppRoutes.generateReports);
                    },
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
