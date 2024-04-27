import 'package:ecommerce_seller_app/views/widgets/text_style.dart';

import '../../../const/const.dart';

Widget orderPlaceDetails(BuildContext context, {title1, title2, d1, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: "$title1", color: purpleColor),
              boldText(text: "$d1", color: redColor),

              // "$title1".text.bold.make(),
              // 3.heightBox,
              // "$d1".text.color(redColor).bold.make(),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: "$title2", color: purpleColor),
              boldText(text: "$d2", color: darkFontGrey),

              // "$title2".text.bold.make(),
              // 3.heightBox,
              // "$d2".text.color(darkFontGrey).bold.make(),
            ],
          ),
        ),
      ],
    ),
  );
}
