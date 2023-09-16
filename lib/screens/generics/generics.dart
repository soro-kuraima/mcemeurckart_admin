import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/categories_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/generics_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/screens/base_screen/widgets/custom_drawer.dart';

class Generics extends StatelessWidget {
  const Generics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(
                left: Sizes.p8,
              ),
              child: Text(
                'Generics',
                style: Get.textTheme.headlineSmall,
              ),
            ),
            actions: [],
          ),
        ],
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: Sizes.p24,
              right: Sizes.p24,
              bottom: Sizes.p24,
            ),
            child: GetBuilder<GenericsController>(
              builder: (genericsController) {
                return GetBuilder<CategoriesController>(
                  builder: (categoriesController) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: genericsController.generics.isNotEmpty,
                          replacement: EmptyStateCard(
                            hasDescription: false,
                            cardImage: AppAssets.wishlistEmpty,
                            cardTitle: 'Add generics',
                            cardColor: AppColors.purple300,
                            buttonText: 'Add all generics',
                            buttonPressed: () {},
                          ),
                          child: SizedBox(
                            height: Get.height * .85,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.only(
                                  left: Sizes.p6,
                                  right: Sizes.p6,
                                  bottom: Sizes.p70,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: genericsController.generics.length,
                                itemBuilder: (_, index) => ExpansionTile(
                                      title: Text(genericsController
                                          .generics[index]['title']),
                                      children: [
                                        ...List.generate(
                                          genericsController
                                              .generics[index]['categories']
                                              .length,
                                          (idx) => ListTile(
                                              title: Text(categoriesController
                                                  .getCategory(
                                                      genericsController
                                                                      .generics[
                                                                  index]
                                                              ['categories']
                                                          [idx])['title']),
                                              onTap: () {
                                                final category =
                                                    categoriesController.getCategory(
                                                        genericsController
                                                                .generics[index]
                                                            [
                                                            'categories'][idx]);
                                                if (category['hasProducts']) {
                                                  Get.toNamed(
                                                      AppRoutes.category,
                                                      arguments: category);
                                                } else {
                                                  Get.toNamed(
                                                      AppRoutes.categories,
                                                      arguments: category);
                                                }
                                              }),
                                        )
                                      ],
                                    )),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
