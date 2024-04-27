import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/product_controller.dart';
import 'package:ecommerce_app/views/chat_screen/chat_screen.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ItemDetails extends StatelessWidget {
  final String? title;

  final dynamic data;

  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    // var controller = Get.find<ProductController>();
    var controller = Get.put(ProductController());

    var height=MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          leading: IconButton(
              color: whiteColor,
              onPressed: () {
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: title!.text.color(whiteColor).fontFamily(bold).make(),
          actions: [
            IconButton(
              onPressed: () {
                Share.share(
                    "Check out this product: ${data['p_imgs']} \n\nProduct Name: ${data['p_name']} \n\nPrice: ${data['p_price']} ৳ \n\nDescription: ${data['p_desc']}  ");
              },
              icon: const Icon(
                Icons.share,
                color: whiteColor,
              ),
            ),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeToWishList(data.id, context);
                      controller.isFav(false);
                    } else {
                      controller.addToWishList(data.id, context);
                      controller.isFav(true);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : whiteColor,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          viewportFraction: 1.0,
                          height: height/2,
                          itemCount: data["p_imgs"].length,
                          itemBuilder: (context, index) {
                            return Image.network(data['p_imgs'][index],
                                width: double.infinity, fit: BoxFit.cover);
                          }),
                      10.heightBox,
                      //Title and details section...

                      title!.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
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
                      "${data['p_price']}"
                          .numCurrency
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Seller"
                                  .text
                                  .white
                                  .fontFamily(semibold)
                                  .color(whiteColor)
                                  .make(),
                              5.heightBox,
                              "${data['p_seller']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(whiteColor)
                                  .size(16)
                                  .make(),
                            ],
                          )),
                          const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.message_rounded,
                                color: darkFontGrey,
                              )).onTap(() {
                            Get.to(
                              () => const ChatScreen(),
                              arguments: [data['p_seller'], data['vendor_id']],
                            );
                          }),
                        ],
                      )
                          .box
                          .height(60).roundedSM.shadowSm
                          .purple800
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .make(),

                      //Color selection..
                      20.heightBox,
                      Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Color"
                                      .text
                                      .color(darkFontGrey)
                                      .fontFamily(semibold)
                                      .make(),
                                ),
                                Row(
                                  children: List.generate(
                                      data['p_colors'].length,
                                      (index) => Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              VxBox()
                                                  .size(40, 40)
                                                  .roundedFull
                                                  .color(Color(data['p_colors']
                                                          [index])
                                                      .withOpacity(1.0))
                                                  .margin(const EdgeInsets
                                                      .symmetric(horizontal: 4))
                                                  .make()
                                                  .onTap(() {
                                                controller
                                                    .changeColorIndex(index);
                                              }),
                                              Visibility(
                                                  visible: index ==
                                                      controller
                                                          .colorIndex.value,
                                                  child: const Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          )),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),

                            //Quantity row...

                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity"
                                      .text
                                      .color(darkFontGrey)
                                      .fontFamily(semibold)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: const Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(darkFontGrey)
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(data['p_quantity']));
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: const Icon(Icons.add)),
                                      10.widthBox,
                                      "(${data['p_quantity']} available)"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                    ],
                                  ),
                                ),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),

                            //Total count row....

                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total: "
                                      .text
                                      .color(darkFontGrey)
                                      .fontFamily(semibold)
                                      .make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .color(redColor)
                                    .size(16)
                                    .fontFamily(bold)
                                    .make(),
                              ],
                            ).box.padding(const EdgeInsets.all(8)).make(),
                          ],
                        )
                            .box
                            .padding(const EdgeInsets.all(8))
                            .shadowSm
                            .white
                            .make(),
                      ),

                      //Description...
                      20.heightBox,
                      "Description"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(darkFontGrey).make(),

                      //Buttons section...
                      20.heightBox,
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          itemDetailButtonsList.length,
                          (index) => ListTile(
                            title: itemDetailButtonsList[index]
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                            trailing: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),

                      //Products you may also like ...
                      10.heightBox,
                      productsyoumaylike.text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              6,
                              (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(imgP1,
                                          width: 150, fit: BoxFit.cover),
                                      10.heightBox,
                                      "Laptop 4GB/64GB"
                                          .text
                                          .fontFamily(semibold)
                                          .color(whiteColor)
                                          .make(),
                                      10.heightBox,
                                      "\$600"
                                          .text
                                          .fontFamily(bold)
                                          .size(16)
                                          .color(whiteColor)
                                          .make(),
                                    ],
                                  )
                                      .box
                                      .purple800
                                      .rounded
                                      .padding(const EdgeInsets.all(8))
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .roundedSM
                                      .make()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: button(
                  color: purpleColor,
                  onPress: () {
                    if (controller.quantity.value > 0) {
                      controller.addToCart(
                        color: data['p_colors'][controller.colorIndex.value],
                        context: context,
                        vendorID: data['vendor_id'],
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellername: data['p_seller'],
                        title: data['p_name'],
                        tprice: controller.totalPrice.value,
                      );
                      VxToast.show(context,
                          msg: "Added to cart",
                          bgColor: Vx.black,
                          textSize: 18,
                          textColor: whiteColor,
                          pdHorizontal: 30,
                          pdVertical: 15);
                    } else {
                      VxToast.show(context,
                          msg: "Minimum 1 product is required",
                          bgColor: Vx.black,
                          textSize: 18,
                          textColor: whiteColor,
                          pdHorizontal: 30,
                          pdVertical: 15);
                    }
                  },
                  textColor: whiteColor,
                  title: "Add to cart"),
            )
          ],
        ),
      ),
    );
  }
}
