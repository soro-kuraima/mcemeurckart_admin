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

  String? _genericId;
  String? _genericName;
  @override
  Widget build(BuildContext context) {
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
                'Add a new Generic',
                style: Get.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        body: ScrollConfiguration(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      AppAssets.mcemeImage,
                      width: Sizes.deviceWidth * 0.6,
                      height: Sizes.deviceWidth * 0.6,
                    ),
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
                  PrimaryButton(
                    buttonColor: AppColors.neutral800,
                    buttonLabel: 'Add generic',
                    onPressed: () async {
                      if (_addGenericKey.currentState!.validate()) {
                        _addGenericKey.currentState!.save();
                        await FireBaseStoreHelper.addGenerics(_genericId!, {
                          'title': _genericName,
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
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
