import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/services/store_services.dart';
import 'package:ecommerce_seller_app/views/messages_screen/chat_screen.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          title: boldText(text: message, color: whiteColor, size: 18.0),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder(
          stream: StoreServices.getMessages(auth.currentUser!.uid),
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
                      var t = data[index]['created_on'] == null
                          ? DateTime.now()
                          : data[index]['created_on'].toDate();

                      var date =
                          intl.DateFormat("dd/MM/yyyy   h:mm a").format(t);

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
                        leading: CircleAvatar(
                          backgroundColor: purpleColor,
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                        title: boldText(
                            text: "${data[index]['sender_name']}",
                            color: darkFontGrey,
                            size: 18.0),
                        subtitle: normalText(
                            text: "${data[index]['last_msg']}",
                            color: darkFontGrey),
                        trailing: normalText(text: date, color: darkFontGrey),
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
                ),
              );
            }
          },
        ));
  }
}
