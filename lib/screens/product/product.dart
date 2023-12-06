import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/generics_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/products_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/util/firebase_storage_helper.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class Product extends StatefulWidget {
  Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> with TickerProviderStateMixin {
  final _editProductKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _monthlyLimitController = TextEditingController();

  String? _productName;
  String? _productDescription;
  int? _stock;
  int? _price;
  int? _monthlyLimit;

  Uint8List? _imageFile;

  final ImagePicker _imagePicker = ImagePicker();
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
    final productId = Get.arguments;

    final product = Get.find<ProductsController>()
        .products
        .firstWhere((element) => element['id'] == productId);
    final generic = Get.find<GenericsController>().generics.firstWhere(
        (element) => element['id'] == product['generic'],
        orElse: () => {'title': 'Generic not found'});

    _productNameController.value = TextEditingValue(text: product['title']);
    _productDescriptionController.value =
        TextEditingValue(text: product['description']);
    _stockController.value =
        TextEditingValue(text: product['stock'].toString());
    _priceController.value =
        TextEditingValue(text: product['price'].toString());

    _monthlyLimitController.value = TextEditingValue(
        text: product['monthlyLimit'] == null
            ? '0'
            : product['monthlyLimit'].toString());

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  centerTitle: false,
                  title: const Padding(
                    padding: EdgeInsets.only(
                      left: Sizes.p8,
                    ),
                  ),
                  bottom: TabBar(controller: _tabController, tabs: const [
                    Tab(icon: Icon(Icons.edit_outlined), text: "Edit Product"),
                    Tab(
                      icon: Icon(Icons.view_agenda_outlined),
                      text: "View Product",
                    ),
                  ]),
                ),
              ],
          body: TabBarView(controller: _tabController, children: [
            Form(
              key: _editProductKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Sizes.p24,
                  Sizes.p24,
                  Sizes.p24,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Index No: ${product['index'].toString()}",
                      style: Get.textTheme.headlineSmall,
                    ),
                    gapH40,
                    CustomTextArea(
                      labelText: 'Product Name',
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Product Name';
                        }
                        return null;
                      },
                      controller: _productNameController,
                      onSaved: (value) {
                        _productName = value;
                      },
                    ),
                    gapH40,
                    CustomTextField(
                      labelText: 'Price',
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Price';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a valid Price';
                        }
                        return null;
                      },
                      controller: _priceController,
                      onSaved: (value) {
                        _price = int.parse(value!);
                      },
                    ),
                    gapH40,
                    CustomTextField(
                      labelText: 'Stock',
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Stock';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a valid Stock';
                        }
                        return null;
                      },
                      controller: _stockController,
                      onSaved: (value) {
                        _stock = int.parse(value!);
                      },
                    ),
                    gapH40,
                    CustomTextField(
                      labelText: 'Monthly Limit',
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Stock';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a valid Stock';
                        }
                        return null;
                      },
                      controller: _monthlyLimitController,
                      onSaved: (value) {
                        _monthlyLimit = int.parse(value!);
                      },
                    ),
                    gapH40,
                    CustomTextArea(
                      labelText: 'Description',
                      minlines: 3,
                      maxlines: 8,
                      textInputType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Description';
                        }
                        return null;
                      },
                      controller: _productDescriptionController,
                      onSaved: (value) {
                        _productDescription = value;
                      },
                    ),
                    gapH40,
                    SizedBox(
                      child: GestureDetector(
                        onTap: () async {
                          final pickedImage = await _imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          final data = await pickedImage?.readAsBytes();

                          setState(() {
                            _imageFile = data;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.neutral500),
                            borderRadius: BorderRadius.circular(Sizes.p8),
                          ),
                          child: Center(
                              child: _imageFile != null
                                  ? Image.memory(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: Sizes.deviceWidth * 0.85,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: product['imageUrl'],
                                      fit: BoxFit.cover,
                                      width: Sizes.deviceWidth * 0.85)),
                        ),
                      ),
                    ),
                    gapH40,
                    PrimaryButton(
                      buttonColor: AppColors.neutral800,
                      buttonLabel: 'Save',
                      onPressed: () async {
                        if (_editProductKey.currentState!.validate()) {
                          _editProductKey.currentState!.save();

                          late final imageUrl;

                          if (_imageFile != null) {
                            await FirebaseStorageHelper.uploadProductImage(
                                _imageFile!);
                          } else {
                            imageUrl = product['imageUrl'];
                          }

                          await FireBaseStoreHelper.updateProduct({
                            'id': product['id'],
                            'index': product['index'],
                            'title': _productName,
                            'description': _productDescription,
                            'stock': _stock,
                            'price': _price,
                            'imageUrl': imageUrl,
                            'monthlyLimit': _monthlyLimit
                          });
                        }
                        Get.snackbar(
                          "Product updated Successfully",
                          "",
                          backgroundColor: AppColors.green500,
                          colorText: AppColors.white,
                          duration: const Duration(seconds: 2),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        _editProductKey.currentState!.reset();
                        setState(() {
                          _imageFile = null;

                          _productNameController.value = TextEditingValue.empty;
                          _productDescriptionController.value =
                              TextEditingValue.empty;
                          _stockController.value = TextEditingValue.empty;
                          _priceController.value = TextEditingValue.empty;
                        });
                      },
                    ),
                    gapH40,
                  ],
                ),
              ),
            ),
            ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //* Product Image
                    Stack(
                      children: [
                        Container(
                          height: Sizes.deviceHeight * .50,
                          alignment: Alignment.center,
                          color: AppColors.blue300,
                          child: CachedNetworkImage(
                            imageUrl: product['imageUrl'],
                            placeholder: (_, url) => const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //* Product Title
                    Padding(
                      padding: const EdgeInsets.all(
                        Sizes.p24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: Get.textTheme.headlineMedium,
                          ),
                          gapH12,
                          Text(
                            'Index No',
                            style: Get.textTheme.displayLarge,
                          ),
                          gapH8,
                          TextCroppingWidget(
                            text: product['index'].toString(),
                          ),
                          gapH12,
                          Text(
                            'Price',
                            style: Get.textTheme.displayLarge,
                          ),
                          gapH8,
                          TextCroppingWidget(
                            text: '₹ ${product['price']} /-',
                          ),
                          gapH12,
                          Text(
                            'Stock',
                            style: Get.textTheme.displayLarge,
                          ),
                          gapH8,
                          TextCroppingWidget(
                            text: product['stock'].toString(),
                          ),
                          gapH12,
                          Text(
                            'Monthly Limit',
                            style: Get.textTheme.displayLarge,
                          ),
                          gapH8,
                          TextCroppingWidget(
                            text: product['monthlyLimit'] == null
                                ? 'NA'
                                : product['monthlyLimit'].toString(),
                          ),
                          gapH12,
                          Text(
                            'Generic',
                            style: Get.textTheme.displayLarge,
                          ),
                          gapH8,
                          TextCroppingWidget(
                            text: generic['title'],
                          ),

                          gapH12,
                          //* Available Colors

                          Text(
                            'Description',
                            style: Get.textTheme.displayLarge,
                          ),
                          gapH8,
                          TextCroppingWidget(
                            text: product['description'],
                          ),
                          gapH40,
                          PrimaryButton(
                            buttonColor: AppColors.red500,
                            buttonLabel: 'Delete',
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                    "Delete Product with Index No ${product['index']}"),
                                content: const Text(
                                    'This will delete the product permanently.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FireBaseStoreHelper.deleteProduct(
                                          product['id']);

                                      Get.snackbar(
                                        "Product with index ${product['index']} deleted}",
                                        "",
                                        backgroundColor: AppColors.red500,
                                      );
                                      Get.offNamed(AppRoutes.products);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
