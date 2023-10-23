import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/products_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/screens/base_screen/widgets/custom_drawer.dart';
import 'package:mcemeurckart_admin/util/firebase_storage_helper.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class ViewCategory extends StatefulWidget {
  ViewCategory({super.key});

  @override
  State<ViewCategory> createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  final category = {}.obs;

  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _imageFile;

  bool updateImage = false;

  @override
  Widget build(BuildContext context) {
    category.value = Get.arguments;
    final products = Get.find<ProductsController>()
        .products
        .where((product) => product['category'] == category['id'])
        .toList();
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
                      category['title'],
                      style: Get.textTheme.headlineSmall,
                    ),
                  ),
                  actions: [],
                ),
              ],
          body: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.only(
                  bottom: Sizes.p24,
                ),
                child: Column(
                  children: [
                    _imageFile != null
                        ? Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(Sizes.p32),
                                child: Image.memory(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                  width: Sizes.deviceWidth * 0.5,
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                      updateImage = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          )
                        : Obx(() => Container(
                              padding: const EdgeInsets.all(Sizes.p32),
                              child: CachedNetworkImage(
                                alignment: Alignment.center,
                                placeholder: (_, url) => const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                                imageUrl: category['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            )),
                    gapH12,
                    PrimaryOutlinedButton(
                      hasText: true,
                      title: updateImage ? 'Confirm' : 'Update Image',
                      onPressed: () async {
                        if (updateImage) {
                          String imageUrl =
                              await FirebaseStorageHelper.uploadCategoryImage(
                                  _imageFile!);
                          await FireBaseStoreHelper.updateCategoryImage(
                              category['id'], imageUrl);

                          Get.snackbar("", "Image updated successfully");

                          setState(() {
                            updateImage = false;
                            category['imageUrl'] = imageUrl;
                            _imageFile = null;
                          });
                        } else {
                          final pickedImage = await _imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          final data = await pickedImage?.readAsBytes();
                          setState(() {
                            if (data != null) {
                              _imageFile = data;
                              updateImage = true;
                            }
                          });
                        }
                      },
                    ),
                    gapH16,
                    Text(
                      'Products',
                      style: Get.textTheme.headlineSmall,
                    ),
                    gapH16,
                    GetBuilder<ProductsController>(
                      builder: (productsController) {
                        return ListView.separated(
                            itemCount: products.length,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => gapH16,
                            itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.p70,
                                  ),
                                  child: Container(
                                    width: Sizes.deviceWidth * .5,
                                    height: Sizes.deviceHeight * 0.4,
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                      horizontal: Sizes.p16,
                                      vertical: Sizes.p16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.neutral200,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          Sizes.p10,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Index No: ${products[index]['index']}",
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.displayMedium
                                              ?.copyWith(
                                            fontWeight: Fonts.interSemiBold,
                                          ),
                                        ),
                                        gapH10,
                                        Center(
                                          child: CachedNetworkImage(
                                            alignment: Alignment.center,
                                            placeholder: (_, url) =>
                                                const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            ),
                                            imageUrl: products[index]
                                                ['imageUrl'],
                                            height:
                                                Sizes.deviceHeight * 0.3 / 1.5,
                                            width: Sizes.deviceWidth * 0.5,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        gapH10,
                                        Text(
                                          "Price: Rs. ${products[index]['price']}/-",
                                          style: Get.textTheme.displayMedium
                                              ?.copyWith(
                                            fontWeight: Fonts.interSemiBold,
                                          ),
                                        ),
                                        gapH10,
                                        PrimaryOutlinedButton(
                                          hasText: true,
                                          title: "Edit Product",
                                          onPressed: () => {
                                            Get.toNamed(AppRoutes.product,
                                                arguments: products[index]
                                                    ['id'])
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
              ))),
    );
  }
}
