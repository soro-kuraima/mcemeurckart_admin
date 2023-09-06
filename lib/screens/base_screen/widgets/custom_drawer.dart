import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/app_colors.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.controller});

  final PageController controller;

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
                      'user name',
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
                  title: const Text('Add User'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    controller.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                    //Get.toNamed(AppRoutes.addUser);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40.0),
                  title: const Text('View Users'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    controller.animateToPage(2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 40.0),
                  title: const Text('Requested Users'),
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    controller.animateToPage(3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
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
                      controller.animateToPage(4,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Add Generic'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      controller.animateToPage(5,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
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
                      controller.animateToPage(6,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('View Categories'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      controller.animateToPage(7,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
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
                      controller.animateToPage(8,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Products'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      controller.animateToPage(9,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
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
                      controller.animateToPage(10,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 40.0),
                    title: const Text('Generate Reports'),
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      controller.animateToPage(2,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
