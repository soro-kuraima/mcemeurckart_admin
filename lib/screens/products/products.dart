import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/app_sizes.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/products_controller.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/screens/product/widgets/products_card.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    List<dynamic> products = [...Get.find<ProductsController>().products];
    log(products.toString());
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) => [
            SliverAppBar(
              title: Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.p8,
                ),
                child: Text(
                  'Products',
                  style: TextStyle(
                      color: AppColors.neutral800, fontSize: Sizes.p20),
                ),
              ),
            ),
          ],
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: GetBuilder<ProductsController>(
                  builder: (productsController) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(
                        Sizes.p8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                            itemCount: products.length,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // mainAxisSpacing: Sizes.p16,
                              crossAxisSpacing: Sizes.p6,
                              childAspectRatio: 9 / 10,
                            ),
                            itemBuilder: (_, index) => ProductsCard(
                              title: products[index]['title'],
                              price: products[index]['price'],
                              height: Sizes.deviceHeight * 0.6,
                              imageUrl: products[index]['imageUrl'],
                              onCardTap: () {
                                Get.toNamed(AppRoutes.product,
                                    arguments: products[index]['id']);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
