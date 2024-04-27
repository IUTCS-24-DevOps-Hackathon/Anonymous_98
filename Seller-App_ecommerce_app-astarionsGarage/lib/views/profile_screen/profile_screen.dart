import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/auth_controller.dart';
import 'package:ecommerce_seller_app/controllers/profile_controller.dart';
import 'package:ecommerce_seller_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_seller_app/views/messages_screen/messages_screen.dart';
import 'package:ecommerce_seller_app/views/shop_screen/shop_settings_screen.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../../services/firestore_service.dart';
import '../widgets/text_style.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    var userStream = FireStoreServices.getUser(auth.currentUser!.uid);
    var width = MediaQuery.of(context).size.width;
    var controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: purpleColor,
        title: boldText(text: settings, color: whiteColor, size: 18.0),
        actions: [
          IconButton(
              onPressed: () async {
                // Clear the text fields
                controller.oldpassController.clear();
                controller.newpassController.clear();
                Get.to(() => EditProfileScreen(
                    username: controller.snapshotData['vendor_name']));
              },
              icon: Icon(
                Icons.edit,
                color: whiteColor,
              )),
          TextButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => LoginScreen());
              },
              child: normalText(text: logout, size: 16.0))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: userStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: loadingIndicator());
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                controller.snapshotData = snapshot.data!.docs[0];

                return Column(
                  children: [
                    ListTile(
                      leading: controller.snapshotData['imageUrl'] == ''
                          ? Image.asset(
                              icProduct,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.network(
                              controller.snapshotData['imageUrl'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                      title: boldText(
                          text: "${controller.snapshotData['vendor_name']}",
                          color: darkFontGrey,
                          size: 18.0),
                      subtitle: normalText(
                          text: "${controller.snapshotData['email']}",
                          color: grayColor,
                          size: 16.0),
                    ),
                    Divider(),
                    10.heightBox,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(
                            profileButtonTitles.length,
                            (index) => ListTile(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        Get.to(ShopSettings());
                                        break;
                                      case 1:
                                        Get.to(MessagesScreen());
                                        break;
                                      default:
                                    }
                                  },
                                  leading: Icon(
                                    profileButtonIcons[index],
                                    color: whiteColor,
                                    size: 30,
                                  ),
                                  title: normalText(
                                      text: profileButtonTitles[index],
                                      color: whiteColor,
                                      size: 18.0),
                                )
                                    .box
                                    .color(purpleColor)
                                    .roundedSM
                                    .width(width - 200)
                                    .height(60)
                                    .margin(EdgeInsets.symmetric(vertical: 5))
                                    .make()),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
