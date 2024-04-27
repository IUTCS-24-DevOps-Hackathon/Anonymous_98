import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:get/get.dart';

import '../../widgets/button.dart';
import '../../widgets/loading_indicator.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          title: "Choose Payment Method".text.fontFamily(semibold).make(),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : button(
                  color: purpleColor,
                  onPress: () async {
                    await controller.placeMyOrder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.totalP.value);
                    await controller.clearCart();
                    // ignore: use_build_context_synchronously
                    VxToast.show(context, msg: "Order placed successfully");
                    Get.offAll(const Home());
                  },
                  textColor: whiteColor,
                  title: "Place My Order",
                ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(paymentMethodsImg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.changePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: controller.paymentIndex.value == index
                              ? const Color.fromRGBO(46, 199, 46, 1.0)
                              : Colors.transparent,
                          width: 4,
                        )),
                    margin: const EdgeInsets.only(bottom: 2),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(paymentMethodsImg[index],
                            width: double.infinity,
                            height: 110,
                            colorBlendMode:
                                controller.paymentIndex.value == index
                                    ? BlendMode.hue
                                    : BlendMode.darken,
                            color: controller.paymentIndex.value == index
                                ? Colors.green.withOpacity(0.7)
                                : Colors.red.withOpacity(0.1),
                            fit: BoxFit.cover),
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                    activeColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    value: true,
                                    onChanged: (value) {}),
                              )
                            : Container(),
                        Positioned(
                            top: 1,
                            right: 35,
                            child: paymentMethods[index]
                                .text
                                .color(darkFontGrey)
                                .size(15)
                                .fontFamily(semibold)
                                .make())
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
