import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/products_controller.dart';
import 'package:ecommerce_seller_app/services/store_services.dart';
import 'package:ecommerce_seller_app/views/products_screen/add_product.dart';
import 'package:ecommerce_seller_app/views/products_screen/products_details.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../widgets/appBar.dart';
import '../widgets/text_style.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  get intl => null;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: purpleColor,
          onPressed: () async {
            await controller.getCategories();
            controller.populateCategoryList();
            Get.to(() => AddProduct());
          },
          child: Icon(Icons.add),
        ),
        appBar: appBarWidget(products),
        body: StreamBuilder(
          stream: StoreServices.getProducts(auth.currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: loadingIndicator());
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(
                        data.length,
                        (index) => ListTile(
                          onTap: () {
                            Get.to(() => ProductDetails(data: data[index]));
                          },
                          leading: Image.network(
                            data[index]['p_imgs'][0],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          title: boldText(
                              text: "${data[index]['p_name']}",
                              color: darkFontGrey),
                          subtitle: Row(
                            children: [
                              normalText(
                                  text: "${data[index]['p_price']} ৳",
                                  color: grayColor),
                              20.widthBox,
                              boldText(
                                  text: data[index]['is_featured'] == true
                                      ? "Featured"
                                      : '',
                                  color: green),
                            ],
                          ),
                          trailing: VxPopupMenu(
                            arrowSize: 0.0,
                            child: Icon(Icons.more_vert_rounded),
                            horizontalMargin: 10.0,
                            menuBuilder: () => Column(
                              children: List.generate(
                                popupMenuTitles.length,
                                (i) => Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(popupMenuIcons[i],
                                          color: data[index]['featured_id'] ==
                                                      auth.currentUser!.uid &&
                                                  i == 0
                                              ? green
                                              : darkFontGrey),
                                      10.widthBox,
                                      Expanded(
                                        child: normalText(
                                          text: data[index]['featured_id'] ==
                                                      auth.currentUser!.uid &&
                                                  i == 0
                                              ? 'Remove feature'
                                              : popupMenuTitles[i],
                                          color: darkFontGrey,
                                        ),
                                      )
                                    ],
                                  ).onTap(() async {
                                    switch (i) {
                                      case 0:
                                        if (data[index]['is_featured']) {
                                          controller
                                              .removeFeatured(data[index].id);
                                          VxToast.show(context,
                                              msg: "Featured removed");
                                        } else {
                                          controller
                                              .addFeatured(data[index].id);
                                          VxToast.show(context,
                                              msg: "Featured added");
                                        }
                                        break;
                                      case 1:
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                                "Are you sure you want to remove this product?"),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Colors
                                                                  .purple),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: Text(
                                                      "Remove",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );

                                        if (confirm != true) return;

                                        // Remove the product
                                        controller
                                            .removeProduct(data[index].id);
                                        VxToast.show(context,
                                            msg:
                                                "Product removed successfully!!");
                                        break;
                                    }
                                  }),
                                ),
                              ),
                            ).box.white.width(120).rounded.make(),
                            clickType: VxClickType.singleClick,
                          ),
                        )
                            .box
                            .green50
                            .margin(EdgeInsets.symmetric(vertical: 5))
                            .shadowSm
                            .roundedSM
                            .padding(EdgeInsets.all(4))
                            .width(context.screenWidth - 20)
                            .makeCentered(),
                      ),
                    ),
                  ));
            }
          },
        ));
  }
}
