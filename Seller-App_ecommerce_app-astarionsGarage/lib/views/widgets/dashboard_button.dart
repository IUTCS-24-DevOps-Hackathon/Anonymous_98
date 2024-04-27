import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/views/widgets/text_style.dart';

Widget dashboardButton(context, {title, count, icon}) {
  var width = MediaQuery.of(context).size.width;

  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            boldText(text: title, size: 16.0),
            boldText(text: count, size: 20.0),
          ],
        ),
      ),
      Image.asset(
        icon,
        width: 40,
        color: whiteColor,
      )
    ],
  )
      .box
      .color(purpleColor)
      .rounded
      .size(width * 0.4, 80)
      .padding(EdgeInsets.all(8))
      .make();
}
