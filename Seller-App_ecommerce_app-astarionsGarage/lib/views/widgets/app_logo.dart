import '../../const/const.dart';

Widget applogoWidget() {
  return Image.asset(appLogo2)
      .box
      .color(Vx.red300)
      .size(77, 77)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}

