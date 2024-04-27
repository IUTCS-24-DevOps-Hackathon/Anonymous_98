import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/cart_screen/shipping_screen.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:ecommerce_app/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController(auth.currentUser!.uid));

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          automaticallyImplyLeading: false,
          title: "Shopping cart".text.white.fontFamily(semibold).make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder(
              stream: FireStoreServices.getCart(auth.currentUser!.uid),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: "Cart is empty"
                        .text
                        .size(25)
                        .fontFamily(semibold)
                        .color(darkFontGrey)
                        .make(),
                  );
                } else {
                  var data = snapshot.data!.docs;
                  controller.calculate(data);
                  controller.productSnapshot = data;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.network("${data[index]['img']}",
                                  width: 45, fit: BoxFit.cover),
                              title:
                                  "${data[index]['title']}   (x${data[index]['qty']})"
                                      .text
                                      .fontFamily(semibold)
                                      .size(15)
                                      .make(),
                              subtitle: "${data[index]['tprice']}"
                                  .numCurrency
                                  .text
                                  .fontFamily(semibold)
                                  .color(redColor)
                                  .size(14)
                                  .make(),
                              trailing: const Icon(
                                Icons.delete,
                                color: redColor,
                              ).onTap(() {
                                FireStoreServices.deleteDocument(data[index].id);
                              }),
                            )
                                .box
                                .green50
                                .margin(EdgeInsets.symmetric(vertical: 3))
                                .shadow
                                .rounded
                                .padding(EdgeInsets.all(4))
                                .width(context.screenWidth - 20)
                                .makeCentered();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Total price"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          Obx(
                            () => "${controller.totalP.value}"
                                .numCurrency
                                .text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                          ),
                        ],
                      )
                          .box
                          .padding(const EdgeInsets.all(12))
                          .color(lightGolden)
                          .width(context.screenWidth - 60)
                          .roundedSM
                          .make(),
                      10.heightBox,
                      if (data.isNotEmpty) // Check if the cart is not empty
                        SizedBox(
                          width: context.screenWidth,
                          height: 50,
                          child: button(
                            color: purpleColor,
                            onPress: () {
                              Get.to(() => const ShippingDetails());
                            },
                            textColor: whiteColor,
                            title: "Proceed to delivery",
                          ),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  );
                }
              }),
        ));
  }
}
