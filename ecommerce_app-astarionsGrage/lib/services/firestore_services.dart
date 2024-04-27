import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';

class FireStoreServices {
  //Get users data...

  static getUser(uid) {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //Get products data....

  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  static getSubCategoryProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

  //Get cart....

  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  //Delete cart...

  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

//Get all chat messages...

  static Stream<QuerySnapshot> getChatMessages(String docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  //Get all  orders...

  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  //Get all wishlists...

  static getWishlists() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: auth.currentUser!.uid)
        .snapshots();
  }

  //Get all messages.....

  static Stream<QuerySnapshot> getAllMessages() {
    return firestore
        .collection(chatsCollection)
        .where('fromId', isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  //Get counts....

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: auth.currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: auth.currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: auth.currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      })
    ]);
    return res;
  }

  //Get all products...

  static Stream<QuerySnapshot> allproducts() {
    return firestore.collection(productsCollection).snapshots();
  }

  //Get featured products...

  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get(); //If we use future builder then we have to use .get() instead of .snapshots()
  }

  //Get searched products...

  static searchProducts(title) {
    return firestore.collection(productsCollection).get();
  }
}
