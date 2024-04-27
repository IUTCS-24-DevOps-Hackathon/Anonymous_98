import '../../const/const.dart';
import '../widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        title:
            boldText(text: "${data['p_name']}", color: whiteColor, size: 18.0),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VxSwiper.builder(
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  height: height / 2,
                  itemCount: data['p_imgs'].length,
                  itemBuilder: (context, index) {
                    return Image.network(data['p_imgs'][index],
                        width: double.infinity, fit: BoxFit.cover);
                  }),
              10.heightBox,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(
                        text: "${data['p_name']}",
                        color: darkFontGrey,
                        size: 20.0),
                    10.heightBox,
                    Row(
                      children: [
                        boldText(
                            text: "${data['p_category']}",
                            color: darkFontGrey,
                            size: 18.0),
                        10.widthBox,
                        normalText(
                            text: "${data['p_subcategory']}",
                            color: darkFontGrey,
                            size: 16.0),
                      ],
                    ),
                    10.heightBox,
                    //Rating...
                    VxRating(
                      isSelectable: false,
                      value: double.parse(data['p_rating']),
                      onRatingUpdate: (value) {},
                      normalColor: textfieldGrey,
                      selectionColor: golden,
                      count: 5,
                      maxRating: 5,
                      size: 25,
                      stepInt: true,
                    ),
                    10.heightBox,
                    boldText(
                        text: "${data['p_price']} ৳",
                        color: redColor,
                        size: 18.0),
                    20.heightBox,
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child:
                                  boldText(text: "Colors", color: darkFontGrey),
                            ),
                            Row(
                              children: List.generate(
                                2,
                                (index) => VxBox()
                                    .size(40, 40)
                                    .roundedFull
                                    .color(Color(data['p_colors'][index])
                                        .withOpacity(1.0))
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .make()
                                    .onTap(() {}),
                              ),
                            ),
                          ],
                        ),
                        15.heightBox,
                        //Quantity row...

                        Row(
                          children: [
                            SizedBox(
                                width: 100,
                                child: boldText(
                                    text: "Quantity", color: darkFontGrey)),
                            boldText(
                                text: "${data['p_quantity']}  items",
                                color: darkFontGrey),
                          ],
                        ),

                        //Total count row....
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(8))
                        .shadowSm
                        .white
                        .make(),
                    10.heightBox,
                    Divider(
                      color: darkFontGrey,
                    ),
                    20.heightBox,
                    boldText(text: "Description", color: darkFontGrey),

                    10.heightBox,
                    normalText(
                        text:
                            "${data['p_desc']}",
                        color: darkFontGrey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
