import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/orders_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

import 'widgets/order_card.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders = Get.find<OrdersController>()
        .orders
        .where((element) => element['orderStatus'] == 'pending')
        .toList();
    final deliveredOrders =
        Get.find<OrdersController>().orders.where((element) {
      return element['orderStatus'] == 'delivered';
    }).toList();
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.p8,
            ),
            child: Text(
              'Orders',
              style: Get.textTheme.headlineSmall,
            ),
          ),
          bottom: TabBar(controller: _tabController, tabs: const [
            Tab(text: "Pending"),
            Tab(
              text: "Delivered",
            ),
          ]),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: Sizes.p24,
                right: Sizes.p24,
              ),
              child: GetBuilder<OrdersController>(
                builder: (ordersController) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: pendingOrders.isNotEmpty,
                        replacement: EmptyStateCard(
                          hasDescription: false,
                          cardImage: AppAssets.wishlistEmpty,
                          cardTitle: 'No orders yet',
                          cardColor: AppColors.purple300,
                          buttonText: 'Add new Products',
                          buttonPressed: () {
                            Get.offAllNamed(AppRoutes.addProduct);
                          },
                        ),
                        child: SizedBox(
                          height: Get.height * .85,
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p6,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: pendingOrders.length,
                              separatorBuilder: (_, index) => gapH4,
                              itemBuilder: (_, index) {
                                return OrderCard(
                                    orderId:
                                        pendingOrders[index]['orderId'] ?? '',
                                    imageUrl:
                                        pendingOrders[index]['imageUrl'] ?? '',
                                    orderStatus: pendingOrders[index]
                                            ['orderStatus'] ??
                                        '',
                                    orderValue: pendingOrders[index]
                                            ['orderValue']
                                        .toString(),
                                    onCardTap: () async {
                                      await ordersController.setOrderItem(
                                          pendingOrders[index]['orderId']);
                                      Get.toNamed(AppRoutes.order);
                                    });
                              }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: Sizes.p24,
                right: Sizes.p24,
              ),
              child: GetBuilder<OrdersController>(
                builder: (ordersController) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: deliveredOrders.isNotEmpty,
                        replacement: EmptyStateCard(
                          hasDescription: false,
                          cardImage: AppAssets.wishlistEmpty,
                          cardTitle: 'No orders yet',
                          cardColor: AppColors.purple300,
                          buttonText: 'Add new Products',
                          buttonPressed: () {
                            Get.offAllNamed(AppRoutes.addProduct);
                          },
                        ),
                        child: SizedBox(
                          height: Get.height * .85,
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p6,
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: deliveredOrders.length,
                              separatorBuilder: (_, index) => gapH4,
                              itemBuilder: (_, index) {
                                return OrderCard(
                                    orderId:
                                        deliveredOrders[index]['orderId'] ?? '',
                                    imageUrl: deliveredOrders[index]
                                            ['imageUrl'] ??
                                        '',
                                    orderStatus: deliveredOrders[index]
                                            ['orderStatus'] ??
                                        '',
                                    orderValue: deliveredOrders[index]
                                            ['orderValue']
                                        .toString(),
                                    onCardTap: () async {
                                      ordersController
                                          .setOrderItem(
                                              deliveredOrders[index]['orderId'])
                                          .then((value) =>
                                              Get.toNamed(AppRoutes.order));
                                    });
                              }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
