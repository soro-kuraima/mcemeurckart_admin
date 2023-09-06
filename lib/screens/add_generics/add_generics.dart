import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/common_widgets/index.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/util/firestore_helper.dart';

class AddGenerics extends StatefulWidget {
  const AddGenerics({super.key});

  @override
  State<AddGenerics> createState() => _AddGenericsState();
}

class _AddGenericsState extends State<AddGenerics> {
  final _addGenericKey = GlobalKey<FormState>();

  final _genericIdController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _genericCategoriesController = TextEditingController();

  String? _genericId;
  String? _genericName;
  final List<String> _categories = [];
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: Form(
        key: _addGenericKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Sizes.p24,
            Sizes.p24,
            Sizes.p24,
            0,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                AppAssets.appLogoMceme,
                width: Sizes.p100,
                height: Sizes.p100,
              ),
              gapH48,
              Text(
                'Add a new Generic',
                style: Get.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              gapH16,
              const CustomDivider(
                hasText: false,
              ),
              gapH40,
              CustomTextField(
                labelText: 'Generic ID',
                textInputType: TextInputType.name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a generic id';
                  }
                  if (value.length < 6) {
                    return 'Generic Id must be at least 6 characters';
                  }

                  return null;
                },
                controller: _genericIdController,
                onSaved: (value) {
                  _genericId = value;
                },
              ),
              gapH16,
              CustomTextField(
                labelText: 'Generic Name',
                isSecret: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Generic Name';
                  }

                  return null;
                },
                controller: _genericNameController,
                onSaved: (value) {
                  _genericName = value;
                },
              ),
              gapH40,
              CustomTextField(
                labelText: 'Categories',
                controller: _genericCategoriesController,
              ),
              gapH40,
              ElevatedButton(
                onPressed: () {
                  if (_genericCategoriesController.text.isNotEmpty) {
                    setState(() {
                      _categories.add(_genericCategoriesController.text);
                      _genericCategoriesController.clear();
                    });
                  }
                },
                child: Text('Add Category'),
              ),
              _categories.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(_categories[index]),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _categories.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ));
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              PrimaryButton(
                buttonColor: AppColors.neutral800,
                buttonLabel: 'Add generic',
                onPressed: () async {
                  log("login button pressed");
                  if (_categories.isEmpty) {
                    Get.snackbar(
                      "No Categories Provided",
                      "Add atleast one category",
                      backgroundColor: AppColors.red400,
                      colorText: AppColors.white,
                      duration: const Duration(seconds: 3),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                  if (_addGenericKey.currentState!.validate()) {
                    _addGenericKey.currentState!.save();
                    await FireBaseStoreHelper.addGenerics(_genericId!, {
                      'title': _genericName,
                      'categories': _categories,
                    });

                    Get.snackbar(
                      "Generic Added",
                      "Generic Added Successfully",
                      backgroundColor: AppColors.green500,
                      colorText: AppColors.white,
                      duration: const Duration(seconds: 3),
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    _genericIdController.clear();
                    _genericNameController.clear();
                    _genericCategoriesController.clear();
                    setState(() {
                      _categories.clear();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
