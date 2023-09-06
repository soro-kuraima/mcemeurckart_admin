import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcemeurckart_admin/controller/categories_controller.dart';
import 'package:mcemeurckart_admin/controller/generics_controller.dart';
import 'package:mcemeurckart_admin/util/firebase_storage_helper.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _addProductKey = GlobalKey<FormState>();

  final _productIndexController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  int? _productIndex;
  String? _productName;
  String? _productDescription;
  int? _stock;
  int? _price;
  String? _generic;
  String? _category;
  Uint8List? _imageFile;

  final ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Form(
        key: _addProductKey,
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
              SvgPicture.asset(
                AppAssets.appLogoMceme,
                width: Sizes.p100,
                height: Sizes.p100,
              ),
              gapH48,
              Text(
                'Add a new Product',
                style: Get.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              gapH16,
              const CustomDivider(
                hasText: false,
              ),
              gapH40,
              CustomTextField(
                labelText: 'Index No',
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Index No';
                  }
                  return null;
                },
                controller: _productIndexController,
                onSaved: (value) {
                  _productIndex = int.parse(value!);
                },
              ),
              gapH16,
              CustomTextField(
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
              GetBuilder<GenericsController>(
                builder: (genericsController) {
                  return DropdownButtonFormField<String>(
                    hint: Text('Select a Generic'),
                    decoration: const InputDecoration(
                      labelText: 'Generic',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a Category';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _generic = value;
                      });
                    },
                    items: genericsController.generics.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'],
                        child: Text(item['title']),
                      );
                    }).toList(),
                  );
                },
              ),
              gapH40,
              GetBuilder<CategoriesController>(
                builder: (categoriesController) {
                  return DropdownButtonFormField<String>(
                    hint: Text('Select a Category'),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a Category';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    items: categoriesController.productCategories.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'],
                        child: Text(item['title']),
                      );
                    }).toList(),
                  );
                },
              ),
              gapH40,
              const Text(
                'Product Image',
                textAlign: TextAlign.left,
              ),
              gapH16,
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
                          : Icon(
                              Icons.add_a_photo,
                              color: AppColors.neutral500,
                              size: Sizes.p100,
                            ),
                    ),
                  ),
                ),
              ),
              gapH40,
              PrimaryButton(
                buttonColor: AppColors.neutral800,
                buttonLabel: 'Add Product',
                onPressed: () async {
                  if (_imageFile == null) {
                    Get.snackbar("", "Please provide a product image");
                  }

                  if (_addProductKey.currentState!.validate()) {
                    _addProductKey.currentState!.save();

                    final imageUrl =
                        await FirebaseStorageHelper.uploadProductImage(
                            _imageFile!);

                    final product = {
                      'index': _productIndex,
                      'title': _productName,
                      'description': _productDescription,
                      'stock': _stock,
                      'price': _price,
                      'generic': _generic,
                      'imageUrl': imageUrl,
                      'category': _category,
                    };

                    await FireBaseStoreHelper.addProduct(product);
                  }
                  Get.snackbar(
                    "Product Added Successfully",
                    "Add more products",
                    backgroundColor: AppColors.green500,
                    colorText: AppColors.white,
                    duration: const Duration(seconds: 3),
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  _addProductKey.currentState!.reset();
                  setState(() {
                    _imageFile = null;
                    _productIndexController.value = TextEditingValue.empty;
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
    );
  }
}
