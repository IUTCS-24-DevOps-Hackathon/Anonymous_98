import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/category_screen/category_details.dart';
import 'package:get/get.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(
        icon,
        width: 60,
        fit: BoxFit.fill,
      ),
      10.widthBox,
      Flexible(
        child: Text(
          title!,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: semibold,
            color: darkFontGrey,
          ),
        ),
      ),
    ],
  )
      .box
      .width(200)
      .margin(const EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowMd
      .make()
      .onTap(() {
    Get.to(() => CategoryDetails(title: title));
  });
}

