import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/constants/index.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.baseRoute);
    });
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              height: Sizes.deviceHeight * .9,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: 'MCEME',
                            style: Get.textTheme.headlineLarge!.copyWith(
                                color: AppColors.blue500,
                                fontWeight: FontWeight.w800)),
                        const TextSpan(text: '  '),
                        TextSpan(
                            text: 'URC',
                            style: Get.textTheme.headlineLarge!.copyWith(
                                color: AppColors.red500,
                                fontWeight: FontWeight.bold)),
                      ]),
                      style: Get.textTheme.headlineMedium!.copyWith(
                          color: AppColors.blue500,
                          fontWeight: FontWeight.bold)),
                  Image.asset(AppAssets.mceme,
                      height: Sizes.deviceHeight * .5,
                      width: Sizes.deviceWidth * .8),
                  SpinKitCircle(
                    duration: const Duration(milliseconds: 500),
                    size: 70.0,
                    color: AppColors.blue500,
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
