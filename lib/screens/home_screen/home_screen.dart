import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/orders_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/users_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [...Get.find<UsersController>().users].obs;
    final orders = [...Get.find<OrdersController>().orders].obs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(AppAssets.appLogoBlack)),
                    SizedBox(width: 16),
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                DashboardCard(
                  image: SvgPicture.asset(
                    AppIcons.profileIcon,
                    color: AppColors.blue500,
                    height: Sizes.deviceHeight * 0.07,
                  ),
                  title:
                      FireBaseStoreHelper.getTotalNoOfUsers(users).toString(),
                  subtitle: 'Users',
                  onTap: () {
                    Get.toNamed(AppRoutes.users);
                  },
                ),
                DashboardCard(
                  image: SvgPicture.asset(
                    AppIcons.shoppingBagIcon,
                    color: AppColors.red500,
                    height: Sizes.deviceHeight * 0.07,
                  ),
                  title:
                      FireBaseStoreHelper.getTotalNoOfOrders(orders).toString(),
                  subtitle: 'orders placed',
                  onTap: () {
                    Get.toNamed(AppRoutes.orders);
                  },
                ),
                DashboardCard(
                  image: SvgPicture.asset(AppIcons.ordersIcon,
                      color: AppColors.green500,
                      height: Sizes.deviceHeight * 0.07),
                  title: FireBaseStoreHelper.getTotalNoOfOrdersDelivered(orders)
                      .toString(),
                  subtitle: 'orders delivered',
                  onTap: () {
                    Get.toNamed(AppRoutes.orders);
                  },
                ),
                DashboardCard(
                  image: SvgPicture.asset(
                    AppIcons.lockIcon,
                    color: AppColors.yellow500,
                    height: Sizes.deviceHeight * 0.07,
                  ),
                  title: FireBaseStoreHelper.getTotalRevenueGenerated(orders)
                      .toString(),
                  subtitle: 'in revenue',
                  onTap: () {
                    Get.toNamed(AppRoutes.orders);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final SvgPicture image;
  final String title;
  final String subtitle;
  final void Function() onTap;

  DashboardCard({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Center(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: image),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
