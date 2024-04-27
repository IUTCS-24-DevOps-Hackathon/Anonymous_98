import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:get/get.dart';

import '../../widgets/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  final String? title;

  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: title!.text.white.make(),
          backgroundColor: purpleColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder(
          future: FireStoreServices.searchProducts(title),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: loadingIndicator());
            } else {
              var data = snapshot.data!.docs;
              var filtered = data
                  .where((element) => element['p_name']
                      .toString()
                      .toLowerCase()
                      .contains(title!.toLowerCase()))
                  .toList();
              if (filtered.isEmpty) {
                return "Nothing found 😢 !\nEnter valid keyword 😊"
                    .text
                    .color(darkFontGrey)
                    .size(20)
                    .makeCentered();
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 230,
                    ),
                    children: filtered
                        .mapIndexed(
                          (currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.network(
                                  filtered[index]['p_imgs'][0],
                                  height: height * 0.17,
                                  width: height * 0.17,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Spacer(),
                              "${filtered[index]['p_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              10.heightBox,
                              "${filtered[index]['p_price']} ৳"
                                  .text
                                  .fontFamily(bold)
                                  .size(16)
                                  .color(redColor)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .margin(EdgeInsets.symmetric(horizontal: 4))
                              .padding(EdgeInsets.all(12))
                              .roundedSM
                              .outerShadowMd
                              .make()
                              .onTap(() {
                            Get.to(() => ItemDetails(
                                  title: "${data[index]['p_name']}",
                                  data: data[index],
                                ));
                          }),
                        )
                        .toList(),
                  ),
                );
              }
            }
          },
        ));
  }
}
