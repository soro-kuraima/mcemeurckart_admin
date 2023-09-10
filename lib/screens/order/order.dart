import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/orders_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

import 'widgets/order_product_card.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    final order = Get.find<OrdersController>().orderItem;
    log(order.toString());
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            centerTitle: true,
          ),
        ],
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: Sizes.p12, right: Sizes.p12, bottom: Sizes.p24),
            child: GetBuilder<OrdersController>(builder: (orderController) {
              return Column(
                children: [
                  gapH12,
                  Text(
                    'Order Id',
                    style: Get.textTheme.displayLarge,
                  ),
                  gapH8,
                  Text(
                    order['orderId'],
                    style: Get.textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: Sizes.deviceHeight * 0.65,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p2,
                        vertical: Sizes.p10,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: order['products'].length,
                      separatorBuilder: (_, index) => gapH8,
                      itemBuilder: (_, index) => OrderProductCard(
                        product: order['products'][index],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Total',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral600,
                          ),
                        ),
                        Text(
                          '₹${order['orderValue']} /-',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH40,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Status',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral600,
                          ),
                        ),
                        Text(
                          '₹${order['orderStatus']} /-',
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.yellow300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH12,
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
