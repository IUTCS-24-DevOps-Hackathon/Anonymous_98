import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/orders_controller.dart';
import 'package:ecommerce_seller_app/views/widgets/button.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';
import 'components/order_place_details.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;

  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: purpleColor,
            title:
                boldText(text: "Order Details", color: whiteColor, size: 18.0),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBar: Visibility(
            visible: !controller.confirmed.value,
            child: SizedBox(
              height: 60,
              width: width,
              child: button(
                  color: purpleColor,
                  onPress: () {
                    controller.confirmed(true);
                    controller.changeStatus(
                        title: "order_confirmed",
                        status: true,
                        docID: widget.data.id);
                  },
                  title: "Confirm Order"),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: [
                      //Order Delivery Status Section...........................

                      Visibility(
                        visible: controller.confirmed.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            boldText(text: "Order Status", color: darkFontGrey),
                            SwitchListTile(
                              activeColor: green,
                              value: true,
                              onChanged: (value) {},
                              title:
                                  boldText(text: "Placed", color: darkFontGrey),
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: controller.confirmed.value,
                              onChanged: (value) {
                                controller.confirmed.value = value;
                                 controller.changeStatus(
                                    title: "order_confirmed",
                                    status: value,
                                    docID: widget.data.id);
                              },
                              title: boldText(
                                  text: "Confirmed", color: darkFontGrey),
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: controller.ondelivery.value,
                              onChanged: (value) {
                                controller.ondelivery.value = value;

                                controller.changeStatus(
                                    title: "order_on_delivery",
                                    status: value,
                                    docID: widget.data.id);
                              },
                              title: boldText(
                                  text: "On Delivery", color: darkFontGrey),
                            ),
                            SwitchListTile(
                              activeColor: green,
                              value: controller.delivered.value,
                              onChanged: (value) {
                                controller.delivered.value = value;

                                controller.changeStatus(
                                    title: "order_delivered",
                                    status: value,
                                    docID: widget.data.id);
                              },
                              title: boldText(
                                  text: "Delivered", color: darkFontGrey),
                            )
                          ],
                        )
                            .box
                            .white
                            .padding(EdgeInsets.all(8))
                            .roundedSM
                            .shadowMd
                            .make(),
                      ),
                      10.heightBox,

                      //Order Details Section....
                      Column(
                        children: [
                          orderPlaceDetails(context,
                              d1: "${widget.data['order_code']}",
                              d2: "${widget.data['shipping_method']}",
                              title1: "Order Code",
                              title2: "Shipping Method"),
                          orderPlaceDetails(context,
                              d1: intl.DateFormat()
                                  .add_yMd()
                                  .add_jm()
                                  .format((widget.data['order_date'].toDate())),
                              d2: "${widget.data['payment_method']}",
                              title1: "Order Date",
                              title2: "Payment Method"),
                          orderPlaceDetails(context,
                              d1: "Unpaid",
                              d2: "Ordered Placed",
                              title1: "Payment Status",
                              title2: "Delivery Status"),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    boldText(
                                        text: "Shipping Address",
                                        color: purpleColor),
                                    5.heightBox,
                                    "${widget.data['order_by_name']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_email']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_address']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_city']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_phone']}"
                                        .text
                                        .make(),
                                    "${widget.data['order_by_postalcode']}"
                                        .text
                                        .make(),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.6,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        boldText(
                                            text: "Total Amount",
                                            color: purpleColor),
                                        boldText(
                                            text:
                                                "${widget.data['total_amount']} ৳",
                                            color: redColor,
                                            size: 16.0),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).box.white.roundedSM.shadowMd.make(),
                      const Divider(),
                      10.heightBox,
                      boldText(
                          text: "Ordered Product",
                          color: darkFontGrey,
                          size: 16.0),

                      10.heightBox,
                      ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(controller.orders.length,
                                  (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    orderPlaceDetails(context,
                                        title1:
                                            "${controller.orders[index]['title']}",
                                        title2:
                                            "${controller.orders[index]['tprice']} ৳",
                                        d1: "${controller.orders[index]['qty']} x",
                                        d2: "Refundable"),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Container(
                                        width: 30,
                                        height: 20,
                                        color: Color(
                                            controller.orders[index]['color']),
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                );
                              }).toList())
                          .box
                          .shadowMd
                          .white
                          .margin(const EdgeInsets.only(bottom: 4))
                          .roundedSM
                          .make(),
                      20.heightBox,
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
