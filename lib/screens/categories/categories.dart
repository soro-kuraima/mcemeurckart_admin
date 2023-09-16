import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/categories_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/screens/base_screen/widgets/custom_drawer.dart';

import 'widgets/stagerred_category_card.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final category = Get.arguments;
  final popularCategoriesColors = [
    AppColors.purple300,
    AppColors.blue300,
    AppColors.red300,
    AppColors.green300,
  ];

  @override
  Widget build(BuildContext context) {
    final subCategories = Get.find<CategoriesController>()
        .categories
        .where((element) => category['subCategories'].contains(element['id']))
        .toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blue100,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.p8,
                ),
                child: Text(
                  category['title'],
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
                  itemCount: subCategories.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (_, index) => StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: index.isEven ? 3 : 2,
                    child: StaggeredCard(
                      color: AppColors.neutral200,
                      categoryName: subCategories[index]['title'],
                      imageUrl: subCategories[index]['imageUrl'],
                      onTap: () {
                        final subCategory = Get.find<CategoriesController>()
                            .getCategory(subCategories[index]['id']);

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
