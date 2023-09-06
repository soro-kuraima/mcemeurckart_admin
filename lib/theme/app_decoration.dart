import 'package:flutter/material.dart';

import 'package:mcemeurckart_admin/constants/index.dart';

class AppDecoration {
  static BoxDecoration get fillRedA200 => BoxDecoration(
        color: AppColors.blue100,
      );
  static BoxDecoration get outlineBluegray900 => BoxDecoration(
        border: Border.all(
          color: AppColors.blue100,
        ),
      );
}
