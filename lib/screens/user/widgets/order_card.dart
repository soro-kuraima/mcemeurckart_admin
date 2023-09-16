import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(
      {super.key,
      this.onCardTap,
      required this.imageUrl,
      required this.orderId,
      required this.orderValue,
      required this.orderStatus});

  final VoidCallback? onCardTap;
  final String imageUrl;
  final String orderId;
  final String orderValue;
  final String orderStatus;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Sizes.p10),
      onTap: onCardTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.neutral400,
          ),
          borderRadius: BorderRadius.circular(
            Sizes.p10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p16,
                vertical: Sizes.p8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      placeholder: (_, url) => Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.neutral800,
                          ),
                        ),
                      ),
                      imageUrl: imageUrl,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  gapW16,
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderId,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.neutral400,
                            fontWeight: Fonts.interRegular,
                          ),
                        ),
                        gapH4,
                        Text(
                          orderValue,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: Fonts.interMedium,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        gapH12,
                        Text(
                          orderStatus,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.organge300,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
