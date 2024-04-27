import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/products_controller.dart';
import 'package:ecommerce_seller_app/views/products_screen/components/product_dropdown.dart';
import 'package:ecommerce_seller_app/views/products_screen/components/product_images.dart';
import 'package:ecommerce_seller_app/views/widgets/custom_text_field.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    return Obx(
      () => Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          title: boldText(text: "Edit Product", color: whiteColor, size: 18.0),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            controller.isloading.value
                ? loadingIndicator(color: Colors.white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.editProduct(context);
                      Get.back();
                    },
                    child: Icon(
                      Icons.save,
                      size: 25,
                      color: whiteColor,
                    ),
                  )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                customTextField(
                  hint: "Enter your product name",
                  title: "Product name",
                  sIcon: Icon(
                    Icons.edit,
                    color: redColor,
                    size: 22,
                  ),
                  controller: controller.pnameController,
                ),
                10.heightBox,
                customTextField(
                  isDesc: true,
                  hint: "Write description",
                  title: "Description",
                  sIcon: Icon(
                    Icons.description,
                    color: redColor,
                    size: 22,
                  ),
                  controller: controller.pdescController,
                ),
                10.heightBox,
                customTextField(
                  hint: "Enter product price",
                  title: "Price",
                  sIcon: Icon(
                    Icons.edit,
                    color: redColor,
                    size: 22,
                  ),
                  controller: controller.ppriceController,
                ),
                10.heightBox,
                customTextField(
                  hint: "Enter quantity",
                  title: "Quantity",
                  sIcon: Icon(
                    Icons.edit,
                    color: redColor,
                    size: 22,
                  ),
                  controller: controller.pquantityController,
                ),
                10.heightBox,
                productDropdown(
                  "Choose Category",
                  controller.categoryList,
                  controller.categoryvalue,
                  controller,
                ),
                10.heightBox,
                productDropdown(
                  "Choose Subcategory",
                  controller.subcategoryList,
                  controller.subcategoryvalue,
                  controller,
                ),
                15.heightBox,
                Divider(
                  color: darkFontGrey,
                ),
                15.heightBox,
                Center(
                  child: boldText(
                    text: "Choose Product Images",
                    color: darkFontGrey,
                    size: 16.0,
                  ),
                ),
                10.heightBox,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => controller.pImagesList[index] != null
                          ? Image.file(
                              controller.pImagesList[index],
                              width: 100,
                              height: 100,
                            ).onTap(() {
                              controller.pickImage(index, context);
                            })
                          : productImages(
                              label: "${index + 1}",
                            ).onTap(() {
                              controller.pickImage(index, context);
                            }),
                    ),
                  ),
                ),
                5.heightBox,
                boldText(
                  text: "** First image will be  used as display image",
                  color: redColor,
                  size: 15.0,
                ),
                15.heightBox,
                Divider(
                  color: darkFontGrey,
                ),
                15.heightBox,
                boldText(
                  text: "Choose Product Colors",
                  color: darkFontGrey,
                  size: 16.0,
                ),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      9,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          VxBox()
                              .color(Vx.randomPrimaryColor)
                              .roundedFull
                              .size(50, 50)
                              .make()
                              .onTap(() {
                            controller.selectedColorIndex.value = index;
                          }),
                          controller.selectedColorIndex.value == index
                              ? Icon(
                                  Icons.done,
                                  color: whiteColor,
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
