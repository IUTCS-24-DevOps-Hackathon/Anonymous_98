import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/orders_controller.dart';
import 'package:ecommerce_seller_app/services/store_services.dart';
import 'package:ecommerce_seller_app/views/order_screen/order_details.dart';
import 'package:ecommerce_seller_app/views/widgets/appBar.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(OrdersController());

    return Scaffold(
        appBar: appBarWidget(orders),
        body: StreamBuilder(
          stream: StoreServices.getOrders(auth.currentUser!.uid),
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
                    children: List.generate(data.length, (index) {
                      var time = data[index]['order_date'].toDate();

                      return ListTile(
                        onTap: () {
                          Get.to(() => OrderDetails(data:data[index],));
                        },
                        title: boldText(
                            text: "${data[index]['order_code']}",
                            color: whiteColor,
                            size: 16.0),
                        subtitle: Column(
                          children: [
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.cyanAccent,
                                ),
                                10.widthBox,
                                boldText(
                                    text: intl.DateFormat()
                                        .add_yMd()
                                        .add_jm()
                                        .format(time),
                                    color: whiteColor,
                                    size: 14.1),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: Colors.cyanAccent,
                                ),
                                10.widthBox,
                                boldText(
                                    text: "Unpaid", color: Colors.redAccent)
                              ],
                            ),
                          ],
                        ),
                        trailing:
                            boldText(text: "${data[index]['total_amount']}", color: whiteColor, size: 20.0)
                                .box
                                .padding(EdgeInsets.all(18))
                                .make(),
                      )
                          .box
                          .color(purpleColor)
                          .margin(EdgeInsets.symmetric(vertical: 5))
                          .shadowSm
                          .roundedSM
                          .padding(EdgeInsets.all(4))
                          .width(context.screenWidth - 20)
                          .makeCentered();
                    }),
                  ),
                ),
              );
            }
          },
        ));
  }
}
