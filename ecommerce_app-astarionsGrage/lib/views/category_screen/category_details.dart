import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:ecommerce_app/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;

  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FireStoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FireStoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();

  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: widget.title!.text.white.fontFamily(bold).make(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    controller.subcat.length,
                    (index) => "${controller.subcat[index]}"
                            .text
                            .size(12)
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .makeCentered()
                            .box
                            .green50
                            .shadow
                            .rounded
                            .size(120, 50)
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .make()
                            .onTap(() {
                          switchCategory("${controller.subcat[index]}");
                          setState(() {});
                        })),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: productMethod,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> sanpshot) {
                if (!sanpshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: loadingIndicator(),
                    ),
                  );
                } else if (sanpshot.data!.docs.isEmpty) {
                  return Expanded(
                    child: "No Products Found !!"
                        .text
                        .color(darkFontGrey)
                        .size(18)
                        .makeCentered(),
                  );
                } else {
                  var data = sanpshot.data!.docs;

                  return

                      //Items container....

                      Expanded(
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisExtent: 250,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 8),
                              itemBuilder: (context, index) {
                                return Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(data[index]['p_imgs'][0],
                                        height: 130,
                                        width: 180,
                                        fit: BoxFit.cover),
                                    5.heightBox,
                                    "${data[index]['p_name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    5.heightBox,
                                    "${data[index]['p_price']}"
                                        .numCurrency
                                        .text
                                        .fontFamily(bold)
                                        .size(16)
                                        .color(redColor)
                                        .make(),
                                  ],
                                )
                                    .box
                                    .white
                                    .roundedSM
                                    .shadow
                                    .padding(const EdgeInsets.all(8))
                                    .margin(const EdgeInsets.symmetric(
                                        horizontal: 4))
                                    .make()
                                    .onTap(() {
                                  controller.checkIfFav(data[index]);
                                  Get.to(() => ItemDetails(
                                        title: "${data[index]['p_name']}",
                                        data: data[index],
                                      ));
                                });
                              }));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
