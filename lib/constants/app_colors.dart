import 'dart:ui';

import 'package:flutter/material.dart';

///* Color Styles
class AppColors {
  /* 
  * ========= Primary Colors ==================
   */
  static Color yellow500 = fromHex('#FBC02D');

  static Color yellow300 = fromHex('#FFEB3B');

  static Color yellow100 = fromHex('#FFF9C4');

  /* 
  * ========= Neutral Colors ==================
   */

  static Color neutral900 = fromHex('#1F2223');

  static Color neutral800 = fromHex('#363939');

  static Color neutral700 = fromHex('#57595A');

  static Color neutral600 = fromHex('#797A7B');

  static Color neutral500 = fromHex('#8E9090');

  static Color neutral400 = fromHex('#B1B2B2');

  static Color neutral300 = fromHex('#D2D3D3');

  static Color neutral200 = fromHex('#EAEAEA');

  static Color neutral100 = fromHex('#F6F6F6');

  static Color white = fromHex('#FFFFFF');

  /* 
  * ========= Green Colors ==================
   */

  static Color green700 = fromHex('1E9C40');

  static Color green500 = fromHex('#B4D479');

  static Color green300 = fromHex('#D8E4C2');

  static Color green100 = fromHex('#EEF2E5');

  /* 
  * ========= Red Colors ==================
   */

  static Color red500 = fromHex('#D32F2F');

  static Color red400 = fromHex('#F44336');

  static Color red300 = fromHex('#FF5252');

  static Color red100 = fromHex('#FFCDD2');

  /* 
  * ========= Red Colors ==================
   */

  static Color organge300 = fromHex('#D68F26');

  /* 
  * ========= Blue Colors ==================
   */

  static Color blue500 = fromHex('#1976D2');

  static Color blue300 = fromHex('#2196F3');

  static Color blue100 = fromHex('#E6EEF5');

  /* 
  * ========= Purple Colors ==================
   */

  static Color purple500 = fromHex('#DEAAEF');

  static Color purple300 = fromHex('#E7D1EE');

  static Color purple100 = fromHex('#F6EFF8');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(
      int.parse(buffer.toString(), radix: 16),
    );
  }
}
