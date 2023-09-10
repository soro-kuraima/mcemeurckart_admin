import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';

class OrderProductCard extends StatelessWidget {
  final dynamic product;

  const OrderProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(product.toString());
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Row(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: product['product']['imageUrl'],
                width: 80,
                height: 80,
                placeholder: (_, url) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
            gapW16,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Index No: ${product['product']['index']}',
                    style: Get.textTheme.bodyMedium,
                  ),
                  Text(
                    product['product']['title'],
                    style: Get.textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  gapH8,
                  Text(
                    'Quantity: ${product['quantity']}',
                    style: Get.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            gapW16,
            Text(
              'Price ₹${product['product']['price']} /-',
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: Fonts.interMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
