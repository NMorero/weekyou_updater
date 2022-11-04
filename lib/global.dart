import 'package:flutter/material.dart';

GlobalData GD = GlobalData();
CustomColors CC = CustomColors();

class GlobalData {
  String url = "https://08dsf0bb9k.execute-api.sa-east-1.amazonaws.com/prod";
  String urlS3 = "https://apps-versions-bucket.s3.sa-east-1.amazonaws.com/weekyou";
}

class CustomColors {
  Color orange({double opacity = 1.0}) {
    return Color.fromRGBO(232, 127, 0, opacity);
  }

  Color green({double opacity = 1.0}) {
    return Color.fromRGBO(134, 167, 120, opacity);
  }

  Color yellow({double opacity = 1.0}) {
    return Color.fromRGBO(254, 200, 42, opacity);
  }

  Color red({double opacity = 1.0}) {
    return Color.fromRGBO(238, 81, 50, opacity);
  }

  Color purple({double opacity = 1.0}) {
    return Color.fromRGBO(214, 155, 203, opacity);
  }

  Color blue2({double opacity = 1.0}) {
    return Color.fromRGBO(67, 97, 238, opacity);
  }

  Color blue({double opacity = 1.0}) {
    return Color.fromRGBO(63, 55, 201, opacity);
  }

  Color white({double opacity = 1.0}) {
    return Color.fromRGBO(246, 246, 246, opacity);
  }

  Color grey({double opacity = 1.0}) {
    return Color.fromRGBO(60, 60, 58, opacity);
  }

  Color black({double opacity = 1.0}) {
    return Color.fromRGBO(0, 0, 0, opacity);
  }

  Color primary({double opacity = 1.0}) {
    return Color.fromRGBO(252, 171, 16, opacity);
  }

  Color success({double opacity = 1.0}) {
    return Color.fromRGBO(68, 175, 105, opacity);
  }

  Color danger({double opacity = 1.0}) {
    return Color.fromRGBO(230, 57, 70, opacity);
  }

  Color info({double opacity = 1.0}) {
    return Color.fromRGBO(134, 207, 218, opacity);
  }

  Color warning({double opacity = 1.0}) {
    return Color.fromRGBO(255, 223, 126, opacity);
  }

  Color secondary({double opacity = 1.0}) {
    //
    return Color.fromRGBO(179, 183, 187, opacity);
  }

  Color lightGray({double opacity = 1.0}) {
    //
    return Color.fromRGBO(222, 226, 230, opacity);
  }

  Color scoreColor(double score, {double opacity = 1.0}) {
    if (score > 7) {
      return success();
    } else if (score > 4) {
      return orange();
    } else {
      return danger();
    }
  }
}
