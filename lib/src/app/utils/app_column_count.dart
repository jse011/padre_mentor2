import 'package:flutter/material.dart';
import 'package:padre_mentor/libs/flutter-sized-context/sized_context.dart';
import 'dart:math';

class ColumnCountProvider{
  static double aspectRatioForWidthButtonPortalAgenda(BuildContext? context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context?.widthPx??0;
    if (widthPx >= 1010) {
      return (pixcel) / 1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1;
    } else if (widthPx >= 720) {
      return (pixcel) / 1;
    } else if (widthPx >= 600) {
      return (pixcel) / 1;
    } else if (widthPx >= 480) {
      return (pixcel) / 1;
    }  else if (widthPx >= 360) {
      return (pixcel) / 1.15;
    }else if (widthPx >= 320) {
      return (pixcel) / 1.2;
    } else {
      return (pixcel) / 1.2;
    }
  }
  static double aspectRatioForWidthPortalTarea(BuildContext? context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context?.widthPx??0;
    if (widthPx >= 1010) {
      return (pixcel) / 1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1;
    } else if (widthPx >= 720) {
      return (pixcel) / 1;
    } else if (widthPx >= 600) {
      return (pixcel) / 1;
    } else if (widthPx >= 480) {
      return (pixcel) / 1;
    }  else if (widthPx >= 360) {
      return (pixcel) / 1.15;
    }else if (widthPx >= 320) {
      return (pixcel) / 1.2;
    } else {
      return (pixcel) / 1.2;
    }
  }
  static double aspectRatioForWidthPortalAlumno(BuildContext? context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context?.widthPx??0;
    if (widthPx >= 1010) {
      return (pixcel) / 1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1;
    } else if (widthPx >= 720) {
      return (pixcel) / 1;
    } else if (widthPx >= 600) {
      return (pixcel) / 1;
    } else if (widthPx >= 480) {
      return (pixcel) / 1;
    }  else if (widthPx >= 360) {
      return (pixcel) / 1.15;
    }else if (widthPx >= 320) {
      return (pixcel) / 1.2;
    } else {
      return (pixcel) / 1.2;
    }
  }
  static int columnsForWidthPortalAlumnoOpciones(BuildContext context) {
    double widthPx = context.widthPx;
    if (widthPx >= 900) {
      return 6;
    } else if (widthPx >= 720) {
      return 5;
    } else if (widthPx >= 600) {
      return 4;
    } else if (widthPx >= 480) {
      return 2;
    } else if (widthPx >= 320) {
      return 2;
    } else {
      return 2;
    }
  }
  static double aspectRatioForWidthContactos(BuildContext? context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context?.widthPx??0;
    if (widthPx >= 1010) {
      return (pixcel) / 1;
    }else if (widthPx >= 900) {
      return (pixcel) / 1;
    } else if (widthPx >= 720) {
      return (pixcel) / 1;
    } else if (widthPx >= 600) {
      return (pixcel) / 1;
    } else if (widthPx >= 480) {
      return (pixcel) / 1;
    }  else if (widthPx >= 360) {
      return (pixcel) / 1.15;
    }else if (widthPx >= 320) {
      return (pixcel) / 1.2;
    } else {
      return (pixcel) / 1.2;
    }
  }
  static bool isTablet(MediaQueryData query) {
    var size = query.size;
    var diagonal = sqrt(
        (size.width * size.width) +
            (size.height * size.height)
    );
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static double aspectRatioForWidthLogin(BuildContext context, double pixcel ) {
    // 16 = x 6 / 13
    // 13 = (16 / 6) * X
    // 13 / (16 / 6) = X
    double widthPx = context.widthPx;

    if(context.isLandscape){
      widthPx =  context.heightPx;
    }
    if (widthPx >= 900) {
      return (pixcel) * 1.05;
    } else if (widthPx >= 720) {
      return (pixcel) * 1.05;
    } else if (widthPx >= 600) {
      return (pixcel) * 1.05;
    } else if (widthPx >= 480) {
      return (pixcel) * 1.1;
    }  else if (widthPx >= 360) {
      return (pixcel) / 1;
    }else if (widthPx >= 320) {
      return (pixcel) / 1.05;
    } else {
      return (pixcel) * 1;
    }
  }


  static double aspectRatioForWidthEvaluacion(BuildContext? context, double pixcel ) {
    double widthPx = context?.widthPx??0;
    if (widthPx >= 1010) {
      return (pixcel) * 1.5;
    }else if (widthPx >= 900) {
      return (pixcel) * 1.25;
    } else if (widthPx >= 720) {
      return (pixcel) * 1.25;
    } else if (widthPx >= 600) {
      return (pixcel) * 1.05;
    } else if (widthPx >= 480) {
      return (pixcel) * 1.05;
    }  else if (widthPx >= 360) {
      return (pixcel) / 1.05;
    }else if (widthPx >= 320) {
      return (pixcel) / 1.1;
    } else {
      return (pixcel) / 1.1;
    }
  }

}