import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/orders_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/users_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

import 'widgets/order_card.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: Sizes.p32),
          child: GetBuilder<UsersController>(
            builder: (usersController) {
              final user = usersController.user;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['rank'] ?? '',
                              style: Get.textTheme.displayLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH8,
                            Text(
                              user['displayName'] ?? '',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH8,
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'email: ' + user['email'],
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH8,
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Grocery Card No: ',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH2,
                            Text(
                              user['groceryCardNo'] ?? '',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Address: ' + user['address'],
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: Fonts.interRegular,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH8,
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: user['displayPicture'] != null
                                ? CachedNetworkImage(
                                    imageUrl: user['displayPicture'],
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 100,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                  )
                                : Icon(Icons.person,
                                    size: 100, color: AppColors.neutral400)),
                      ),
                    ],
                  ),
                  gapH16,
                  Center(
                    child: Text(
                      'Orders',
                      style: Get.textTheme.headlineSmall,
                    ),
                  ),
                  gapH8,
                  GetBuilder<OrdersController>(
                    builder: (ordersController) {
                      final orders = ordersController.orders
                          .where((element) => element['user'] == user['email'])
                          .toList();
                      log(orders.toString());
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Visibility(
                            visible: orders.isNotEmpty,
                            replacement: EmptyStateCard(
                              hasDescription: false,
                              cardImage: AppAssets.wishlistEmpty,
                              cardTitle:
                                  'the user has not placed any orders yet',
                              cardColor: AppColors.purple300,
                              buttonText: 'Go Back',
                              buttonPressed: () {
                                Get.back();
                              },
                            ),
                            child: SizedBox(
                              height: Get.height * .50,
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  padding: const EdgeInsets.only(
                                    left: Sizes.p6,
                                    bottom: Sizes.p32,
                                  ),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: orders.length,
                                  separatorBuilder: (_, index) => gapH4,
                                  itemBuilder: (_, index) {
                                    return OrderCard(
                                        orderId: orders[index]['orderId'] ?? '',
                                        imageUrl:
                                            orders[index]['imageUrl'] ?? '',
                                        orderStatus:
                                            orders[index]['orderStatus'] ?? '',
                                        orderValue: orders[index]['orderValue']
                                            .toString(),
                                        onCardTap: () async {
                                          await ordersController.setOrderItem(
                                              orders[index]['orderId']);
                                          Get.toNamed(AppRoutes.order);
                                        });
                                  }),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          )),
    );
  }
}
