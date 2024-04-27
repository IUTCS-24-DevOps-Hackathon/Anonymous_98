import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  //Text controllers for shipping details...

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;

  var placingOrder = false.obs;
  var products = [];
  var vendors = [];

  final String currentUserUID;

  CartController(
      this.currentUserUID); // Accept current user's ID as a parameter in the constructor

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();

    var newOrderRef = firestore.collection(ordersCollection).doc();

    await newOrderRef.set({
      'order_code': newOrderRef.id,
      'order_date': FieldValue.serverTimestamp(),
      'order_by': auth.currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': auth.currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      'order_by_postalcode': postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),
    });

    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'qty': productSnapshot[i]['qty'],
        'tprice': productSnapshot[i]['tprice'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
