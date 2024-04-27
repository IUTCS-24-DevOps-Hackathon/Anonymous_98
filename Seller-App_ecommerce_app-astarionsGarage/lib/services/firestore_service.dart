import '../const/firebase_const.dart';

class FireStoreServices {
  //Get users data...

  static getUser(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

 
}
