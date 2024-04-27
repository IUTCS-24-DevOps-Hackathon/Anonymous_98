import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/views/cart_screen/payment_method.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:ecommerce_app/widgets/custom_textfield.dart';
import 'package:get/get.dart';

import '../../widgets/dismiss_keyboard_on_tap.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return DismissKeyboardOnTap(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: "Shipping Info".text.fontFamily(semibold).make(),
          backgroundColor: purpleColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: button(
            color: purpleColor,
            onPress: () {
              if (controller.phoneController.text.length == 11 &&
                  controller.addressController.text.isNotEmpty &&
                  controller.cityController.text.isNotEmpty &&
                  controller.postalcodeController.text.isNotEmpty &&
                  controller.phoneController.text.isNotEmpty) {
                Get.to(() => const PaymentMethods());
              } else {
                if (controller.phoneController.text.length != 11) {
                  VxToast.show(context, msg: "Phone number must be 11 digits");
                } else {
                  VxToast.show(context, msg: "Please fill all fields");
                }
              }
            },
            textColor: whiteColor,
            title: "Continue",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 360,
            child: Column(
              children: [
                customTextField(
                  keyboardType: TextInputType.streetAddress,
                  hint: "Address",
                  sIcon: Icon(
                    Icons.edit_location_sharp,
                    color: redColor,
                    size: 24,
                  ),
                  title: "Address",
                  controller: controller.addressController,
                ),
                customTextField(
                  keyboardType: TextInputType.streetAddress,
                  hint: "City",
                  sIcon: Icon(
                    Icons.location_city,
                    color: redColor,
                    size: 24,
                  ),
                  title: "City",
                  controller: controller.cityController,
                ),
                customTextField(
                  keyboardType: TextInputType.phone,
                  hint: "Postal Code",
                  sIcon: Icon(
                    Icons.edit_document,
                    color: redColor,
                    size: 24,
                  ),
                  title: "Postal Code",
                  controller: controller.postalcodeController,
                ),
                customTextField(
                  keyboardType: TextInputType.number,
                  hint: "Phone",
                  sIcon: Icon(
                    Icons.phone,
                    color: redColor,
                    size: 24,
                  ),
                  title: "Phone",
                  controller: controller.phoneController,
                ),
              ],
            )
                .box
                .green50
                .shadowMax
                .rounded
                .padding(EdgeInsets.all(16))
                .width(context.screenWidth - 50)
                .makeCentered(),
          ),
        ),
      ),
    );
  }
}
