import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

AppBar appBarWidget(title){
  
  return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: purpleColor,
        title: boldText(text: title, color: whiteColor, size: 18.0),
        actions: [
          Center(
              child: boldText(
            size: 16.0,
            text: intl.DateFormat('EEE,MMM d, ' 'yyyy').format(DateTime.now()),
          )),
          10.widthBox
        ],
      );
}