import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/chat_screen/chat_screen.dart';
import 'package:ecommerce_app/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: "My Messages".text.color(whiteColor).fontFamily(semibold).make(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FireStoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!"
                .text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: [
                                    data[index]['friend_name'],
                                    data[index]['toId'],
                                  ],
                                );
                              },
                              leading: const CircleAvatar(
                                backgroundColor: purpleColor,
                                child: Icon(
                                  Icons.person,
                                  color: whiteColor,
                                ),
                              ),
                              title: "${data[index]['friend_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              subtitle: "${data[index]['last_msg']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(fontGrey)
                                  .make(),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: purpleColor,
                                size: 25,
                              ),
                            )
                                .box
                                .green50
                                .margin(EdgeInsets.symmetric(vertical: 5))
                                .shadowLg
                                .roundedSM
                                .padding(EdgeInsets.all(4))
                                .width(context.screenWidth - 20)
                                .makeCentered();
                          }))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
