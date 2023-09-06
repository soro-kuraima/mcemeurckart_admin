import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcemeurckart_admin/routes/app_routes.dart';
import 'package:mcemeurckart_admin/util/auth_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'constants/index.dart';
import 'theme/theme_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppTitles.appTitle,
      theme: AppThemes().lightTheme,
      darkTheme: AppThemes().darkTheme,
      title: AppTitles.appTitle,
      home: const AuthProvider(),
      getPages: AppPages.pages,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
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
