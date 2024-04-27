import 'package:ecommerce_seller_app/const/colors.dart';
import 'package:ecommerce_seller_app/views/widgets/text_style.dart';
import 'package:flutter/material.dart';

// Widget chatBubble(DocumentSnapshot data) {

  Widget chatBubble(){
  // var t = data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();

  // var date = intl.DateFormat("dd/MM/yyyy").format(t);
  // var time = intl.DateFormat("h:mma").format(t);

  return Directionality(
    // textDirection: data['uid'] == auth.currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    textDirection: TextDirection.rtl,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // color: data['uid'] == auth.currentUser!.uid ? purpleColor:  Vx.black,
        color: purpleColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "${data['msg']}",
          //   style: TextStyle(color: Colors.white, fontSize: 18),
          // ),
          normalText(text: "ABC"),
          SizedBox(height: 15),
          // Text(
          //   date,
          //   style: TextStyle(color:Colors.cyanAccent.withOpacity(1),fontSize: 14),
          // ),
          // Text(
          //   time,
          //   style: TextStyle(color:Colors.yellowAccent.withOpacity(1),fontSize: 13.5),
          // ),
          normalText(text: "4:00 pm"),
        ],
      ),
    ),
  );
}
