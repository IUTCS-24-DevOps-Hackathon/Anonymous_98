import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/views/messages_screen/components/chat_bubbles.dart';

import '../widgets/text_style.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: boldText(text: chats, color: whiteColor, size: 18.0),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: ((context,index) {
                  return chatBubble();
                }),
              ),
            ),
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Enter message...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: purpleColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: purpleColor)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.send_rounded),
                    color: purpleColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
