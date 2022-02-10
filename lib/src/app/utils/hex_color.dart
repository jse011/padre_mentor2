import 'dart:ui';

import 'package:padre_mentor/src/app/utils/app_theme.dart';
import 'package:padre_mentor/src/app/utils/app_utils.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    int i  = int.parse(hexColor, radix: 16);
    print("_getColorFromHex: "+i.toString());
    return i;
  }
}