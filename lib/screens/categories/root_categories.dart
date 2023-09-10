import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/categories_controller.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

import 'widgets/stagerred_category_card.dart';

class RootCategories extends StatefulWidget {
  const RootCategories({super.key});

  @override
  State<RootCategories> createState() => _RootCategoriesState();
}

class _RootCategoriesState extends State<RootCategories> {
  final popularCategoriesColors = [
    AppColors.purple300,
    AppColors.blue300,
    AppColors.red300,
    AppColors.green300,
  ];

  @override
  Widget build(BuildContext context) {
    final categories = Get.find<CategoriesController>()
        .categories
        .where((element) => element['isRoot'])
        .toList();

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.p8,
                ),
                child: Text(
                  'Categories',
                  style: Get.textTheme.headlineSmall,
                ),
              ),
            ),
          ],
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(
                  Sizes.p24,
                ),
                child: MasonryGridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  crossAxisSpacing: Sizes.p16,
                  mainAxisSpacing: Sizes.p16,
                  itemCount: categories.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (_, index) => StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: index.isEven ? 3 : 2,
                    child: StaggeredCard(
                      color: AppColors.neutral200,
                      categoryName: categories[index]['title'],
                      imageUrl: categories[index]['imageUrl'],
                      onTap: () {
                        final subCategory = Get.find<CategoriesController>()
                            .getCategory(categories[index]['id']);

                        if (subCategory['hasSubCategories']) {
                          Get.toNamed(AppRoutes.categories,
                              arguments: subCategory);
                        } else {
                          Get.toNamed(AppRoutes.category,
                              arguments: subCategory);
                        }
                      },
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
