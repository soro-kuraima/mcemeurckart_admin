import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/controller/categories_controller.dart';
import 'package:mcemeurckart_admin/controller/generics_controller.dart';
import 'package:mcemeurckart_admin/util/firebase_storage_helper.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _addCategoryKey = GlobalKey<FormState>();

  final _categoryIdController = TextEditingController();
  final _categoryNameController = TextEditingController();

  String? _categoryId;
  String? _categoryName;
  String? _generic;
  String? _parentCategory;
  bool isRoot = false;
  bool hasProducts = false;
  Uint8List? _imageFile;

  final ImagePicker _imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Form(
        key: _addCategoryKey,
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
                'Add a new Category',
                style: Get.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              gapH16,
              const CustomDivider(
                hasText: false,
              ),
              gapH40,
              CustomTextField(
                labelText: 'Category ID',
                textInputType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Category id';
                  }
                  if (value.length < 6) {
                    return 'Generic ID must be at least 6 characters';
                  }

                  return null;
                },
                controller: _categoryIdController,
                onSaved: (value) {
                  _categoryId = value;
                },
              ),
              gapH16,
              CustomTextField(
                labelText: 'Category Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Category Name';
                  }

                  return null;
                },
                controller: _categoryNameController,
                onSaved: (value) {
                  _categoryName = value;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Is Root Category ?'),
                    Switch(
                        activeColor: AppColors.red400,
                        inactiveThumbColor: AppColors.neutral300,
                        value: isRoot,
                        onChanged: (value) {
                          setState(() {
                            isRoot = value;
                          });
                        }),
                  ],
                ),
              ),
              gapH40,
              !isRoot
                  ? Column(
                      children: [
                        GetBuilder<CategoriesController>(
                          builder: (categoriesController) {
                            return DropdownButtonFormField<String>(
                              hint: Text('Select Parent Category'),
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a Parent Category';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _parentCategory = value;
                                });
                              },
                              items:
                                  categoriesController.categories.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item['id'],
                                  child: Text(item['title']),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        gapH40,
                      ],
                    )
                  : gapH2,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Has Products?'),
                    Switch(
                        activeColor: AppColors.red400,
                        inactiveThumbColor: AppColors.neutral300,
                        value: hasProducts,
                        onChanged: (value) {
                          setState(() {
                            hasProducts = value;
                          });
                        }),
                  ],
                ),
              ),
              gapH40,
              const Text(
                'Category Image',
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
                buttonLabel: 'Add Category',
                onPressed: () async {
                  if (_addCategoryKey.currentState!.validate()) {
                    _addCategoryKey.currentState!.save();
                    String imageUrl =
                        await FirebaseStorageHelper.uploadCategoryImage(
                            _imageFile!);
                    if (isRoot) {
                      Map<String, dynamic> category = {
                        'title': _categoryName,
                        'isRoot': isRoot,
                        'generic': _generic,
                        'imageUrl': imageUrl,
                      };
                      if (hasProducts) {
                        await FireBaseStoreHelper.addRootCategoryWithProducts(
                            _categoryId!, category);
                      } else {
                        await FireBaseStoreHelper.addRootCategory(
                            _categoryId!, category);
                      }
                    } else {
                      Map<String, dynamic> category = {
                        'title': _categoryName,
                        'isRoot': isRoot,
                        'generic': _generic,
                        'imageUrl': imageUrl,
                        'parentId': _parentCategory,
                      };
                      if (hasProducts) {
                        await FireBaseStoreHelper.addCategoryWithProducts(
                            _categoryId!, category);
                      } else {
                        await FireBaseStoreHelper.addCategoryWithSubCategories(
                            _categoryId!, category);
                      }
                    }
                    Get.snackbar(
                      "Category Added",
                      "Add More Categories",
                      backgroundColor: AppColors.green500,
                      colorText: AppColors.white,
                      duration: const Duration(seconds: 3),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    _addCategoryKey.currentState?.reset();
                    setState(() {
                      _imageFile = null;
                      isRoot = false;
                      hasProducts = false;
                      _categoryIdController.value = TextEditingValue.empty;
                      _categoryNameController.value = TextEditingValue.empty;
                    });
                  }
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
