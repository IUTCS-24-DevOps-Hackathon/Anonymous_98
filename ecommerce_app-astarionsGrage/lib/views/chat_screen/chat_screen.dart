import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/chat_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import 'components/sender_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    var height=MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: "${controller.friendName}"
            .text
            .fontFamily(semibold)
            .color(whiteColor)
            .make(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                          stream: FireStoreServices.getChatMessages(
                              controller.chatDocId.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: "Send a message..."
                                    .text
                                    .color(darkFontGrey)
                                    .make(),
                              );
                            } else {
                              return ListView(
                                children: snapshot.data!.docs
                                    .mapIndexed((currentValue, index) {
                                  var data = snapshot.data!.docs[index];
                                  return Align(
                                      alignment:
                                          data['uid'] == auth.currentUser!.uid
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: senderBubble(data));
                                }).toList(),
                              );
                            }
                          })),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      ),
                    ),
                  ),
                )),
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      size: height*0.04,
                      color: purpleColor,
                    )),
              ],
            )
                .box
                .rounded
                .height(height*0.09)
                .margin(const EdgeInsets.only(left: 20, bottom: 8))
                .padding(const EdgeInsets.all(8))
                .make(),
          ],
        ),
      ),
    );
  }
}
