import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/views/products_screen/products_details.dart';
import 'package:ecommerce_seller_app/views/widgets/dashboard_button.dart';
import 'package:get/get.dart';

import '../../services/store_services.dart';
import '../widgets/appBar.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarWidget(dashboard),
      body: StreamBuilder(
          stream: StoreServices.getProducts(auth.currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;
              data = data.sortedBy((a, b) =>
                  b['p_wishlist'].length.compareTo(a['p_wishlist'].length));
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(context,
                            title: products, count: "${data.length}", icon: icProducts),
                        dashboardButton(context,
                            title: orders, count: "15", icon: icOrders),
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(context,
                            title: rating, count: "75", icon: icStart),
                        dashboardButton(context,
                            title: totalSales, count: "15", icon: icProducts),
                      ],
                    ),
                    10.heightBox,
                    Divider(),
                    10.heightBox,
                    boldText(
                        text: popularProducts, size: 16.0, color: darkFontGrey),
                    20.heightBox,
                    Expanded(
                        child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          data.length,
                          (index) =>data[index]['p_wishlist'].length==0?SizedBox(): ListTile(
                                onTap: () {
                                  Get.to(() => ProductDetails(
                                        data: data[index],
                                      ));
                                },
                                leading: Image.network(
                                  data[index]['p_imgs'][0],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                title: boldText(
                                    text: "${data[index]['p_name']}",
                                    color: fontGrey),
                                subtitle: normalText(
                                    text: "\$${data[index]['p_price']}",
                                    color: darkFontGrey),
                              )),
                    ))
                  ]));
            }
          }),
    );
  }
}
