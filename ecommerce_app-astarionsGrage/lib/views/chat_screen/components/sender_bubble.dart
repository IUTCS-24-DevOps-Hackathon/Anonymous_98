import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

Widget senderBubble(DocumentSnapshot data) {
  var t = data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();

  var date = intl.DateFormat("dd/MM/yyyy").format(t);
  var time = intl.DateFormat("h:mma").format(t);

  return Directionality(
    textDirection: data['uid'] == auth.currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: data['uid'] == auth.currentUser!.uid ? purpleColor:  Vx.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${data['msg']}",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 15),
          Text(
            date,
            style: TextStyle(color:Colors.cyanAccent.withOpacity(1),fontSize: 14),
          ),
          Text(
            time,
            style: TextStyle(color:Colors.yellowAccent.withOpacity(1),fontSize: 13.5),
          ),
        ],
      ),
    ),
  );
}
