import 'package:ecommerce_seller_app/controllers/products_controller.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../const/const.dart';
import '../../widgets/text_style.dart';

// Widget productDropdown(
//     hint, list, Rx<String> dropvalue, ProductsController controller) {
//   return DropdownButtonHideUnderline(
//     child: DropdownButton<String>(
//       hint: Center(
//         child: boldText(text: "$hint", color: Vx.gray400, size: 16.0),
//       ),
//       value: dropvalue.value.isEmpty ? null : dropvalue.value,
//       isExpanded: true,
//       items: list.map((e){
//         return DropdownMenuItem(
//           value:e,
//           child:e.toString().text.make());
//       }).toList(),
//       onChanged: (newValue) {
//         if (hint == "Category") {
//           controller.subcategoryvalue.value='';
//           controller.populateSubcategoryList(newValue.toString());
//         }
//         dropvalue.value=newValue.toString();
//       },
//     ),
//   ).box.white.roundedSM.padding(EdgeInsets.symmetric(horizontal: 4)).make();
// }

Widget productDropdown(hint, List<String> list, dropvalue,ProductsController controller) {
  return Obx(()=> DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Center(
          child: boldText(text: "$hint", color: Vx.gray400, size: 16.0),
        ),
        value: dropvalue.value == "" ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(
            child: e.toString().text.make(),
            value: e,
          );
        }).toList(),
        onChanged: (newValue) {
          if (hint == "Choose Category") {
            controller.subcategoryvalue.value='';
            controller.populateSubcategoryList(newValue.toString());
          }
          dropvalue.value=newValue.toString();
        },
      ),
    ).box.white.roundedSM.padding(EdgeInsets.symmetric(horizontal: 4)).make(),
  );
}
