import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/widgets/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: "My Wishlist".text.color(whiteColor).fontFamily(semibold).make(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FireStoreServices.getWishlists(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return "No wishlist yet!"
                  .text
                  .fontFamily(semibold)
                  .color(darkFontGrey)
                  .makeCentered();
            } else {
              var data = snapshot.data!.docs;
              return Column(children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Image.network("${data[index]['p_imgs'][0]}",
                              width: 80, fit: BoxFit.cover),
                          title: "${data[index]['p_name']}"
                              .text
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                          subtitle: "${data[index]['p_price']}"
                              .numCurrency
                              .text
                              .fontFamily(semibold)
                              .color(redColor)
                              .size(16)
                              .make(),
                          trailing: const Icon(
                            Icons.favorite,
                            color: redColor,
                          ).onTap(() async {
                            await firestore
                                .collection(productsCollection)
                                .doc(data[index].id)
                                .set({
                              'p_wishlist': FieldValue.arrayRemove(
                                  [auth.currentUser!.uid])
                            }, SetOptions(merge: true));
                          }),
                        )
                            .box
                            .green50
                            .margin(EdgeInsets.symmetric(vertical: 5))
                            .shadowLg
                            .roundedSM
                            .padding(EdgeInsets.all(4))
                            .width(context.screenWidth - 20)
                            .makeCentered();
                      }),
                ),
              ]);
            }
          },
        ),
      ),
    );
  }
}
