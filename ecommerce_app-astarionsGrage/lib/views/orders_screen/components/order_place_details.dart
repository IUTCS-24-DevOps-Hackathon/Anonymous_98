import '../../../consts/consts.dart';

Widget orderPlaceDetails(BuildContext context,{title1, title2, d1, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width/3.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title1".text.fontFamily(semibold).make(),
              3.heightBox,
              "$d1".text.color(redColor).fontFamily(semibold).make(),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/3.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(semibold).make(),
              3.heightBox,
              "$d2".text.color(darkFontGrey).fontFamily(semibold).make(),
            ],
          ),
        ),
      ],
    ),
  );
}
