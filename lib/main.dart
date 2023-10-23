import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/controller/auth_controller_getx.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'constants/index.dart';
import 'theme/theme_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes().lightTheme,
      darkTheme: AppThemes().darkTheme,
      title: AppTitles.appTitle,
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: Scaffold(body: child!),
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
