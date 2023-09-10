import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/controller/categories_controller.dart';
import 'package:mcemeurckart_admin/controller/generics_controller.dart';
import 'package:mcemeurckart_admin/controller/orders_controller_getx.dart';
import 'package:mcemeurckart_admin/controller/products_controller.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/screens/base_screen/widgets/custom_drawer.dart';
import 'package:mcemeurckart_admin/util/auth_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'constants/index.dart';
import 'theme/theme_provider.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GenericsController());
    Get.put(CategoriesController());
    Get.put(ProductsController());
    Get.put(OrdersController());
    FlutterNativeSplash.remove();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppTitles.appTitle,
      theme: AppThemes().lightTheme,
      darkTheme: AppThemes().darkTheme,
      title: AppTitles.appTitle,
      home: const AuthProvider(),
      getPages: AppPages.pages,
      builder: (context, child) => ResponsiveBreakpoints.builder(
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
            body: child!),
        breakpoints: [
          const Breakpoint(
            start: 0,
            end: 350,
            name: MOBILE,
          ),
          const Breakpoint(
            start: 351,
            end: 600,
            name: TABLET,
          ),
          const Breakpoint(
            start: 601,
            end: 800,
            name: DESKTOP,
          ),
          const Breakpoint(
            start: 801,
            end: double.infinity,
            name: 'XL',
          ),
        ],
      ),
    );
  }
}
