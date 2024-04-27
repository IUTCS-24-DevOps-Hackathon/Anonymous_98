import 'package:ecommerce_seller_app/views/widgets/dismiss_keyboard_on_tap.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../../const/const.dart';
import '../../controllers/profile_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/text_style.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return Obx(
      () => Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          title: boldText(text: shopSettings, color: whiteColor, size: 18.0),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            controller.isloading.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: loadingIndicator(color: whiteColor)),
                  )
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateShop(
                        shopname: controller.shopNameController.text.trim(),
                        shopaddress:
                            controller.shopAddressController.text.trim(),
                        shopmobile: controller.shopMobileController.text.trim(),
                        shopwebsite:
                            controller.shopWebsiteController.text.trim(),
                        shopdesc: controller.shopDescController.text.trim(),
                      );
                      VxToast.show(context, msg: "Updated Successfully");
                    },
                    child: Icon(
                      Icons.save,
                      size: 25,
                      color: whiteColor,
                    ),
                  )
          ],
        ),
        body: DismissKeyboardOnTap(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  customTextField(
                    keyboardType: TextInputType.text,
                    hint: controller.snapshotData['shop_name'].isNotEmpty
                        ? controller.snapshotData['shop_name']
                        : shopNameHint,
                    title: shopName,
                    sIcon: Icon(
                      Icons.edit,
                      color: redColor,
                      size: 25,
                    ),
                    controller: controller.shopNameController,
                  ),
                  customTextField(
                    keyboardType: TextInputType.text,
                    hint: controller.snapshotData['shop_address'].isNotEmpty
                        ? controller.snapshotData['shop_address']
                        : shopAddressHint,
                    title: shopAddress,
                    sIcon: Icon(
                      Icons.location_city,
                      color: redColor,
                      size: 25,
                    ),
                    controller: controller.shopAddressController,
                  ),
                  customTextField(
                    keyboardType: TextInputType.text,
                    hint: controller.snapshotData['shop_mobile'].isNotEmpty
                        ? controller.snapshotData['shop_mobile']
                        : mobileHint,
                    title: mobile,
                    sIcon: Icon(
                      Icons.phone,
                      color: redColor,
                      size: 25,
                    ),
                    controller: controller.shopMobileController,
                  ),
                  customTextField(
                    keyboardType: TextInputType.text,
                    hint: controller.snapshotData['shop_website'].isNotEmpty
                        ? controller.snapshotData['shop_website']
                        : shopWebsiteHint,
                    title: website,
                    sIcon: Icon(
                      Icons.link,
                      color: redColor,
                      size: 25,
                    ),
                    controller: controller.shopWebsiteController,
                  ),
                  customTextField(
                    isDesc: true,
                    keyboardType: TextInputType.text,
                    hint: controller.snapshotData['shop_desc'].isNotEmpty
                        ? controller.snapshotData['shop_desc']
                        : shopDescHint,
                    title: description,
                    sIcon: Icon(
                      Icons.description,
                      color: redColor,
                      size: 25,
                    ),
                    controller: controller.shopDescController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
