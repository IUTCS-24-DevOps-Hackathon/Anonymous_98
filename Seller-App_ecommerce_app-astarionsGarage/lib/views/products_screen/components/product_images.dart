import 'package:ecommerce_seller_app/const/const.dart';

Widget productImages({required label,onPress}) {
  return "$label"
      .text
      .bold
      .color(darkFontGrey)
      .size(16.0)
      .makeCentered()
      .box
      .red300
      .roundedSM
      .size(100, 100)
      .make();
}
