import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/chat_screen/messaging_screen.dart';
import 'package:ecommerce_app/views/orders_screen/orders_screen.dart';
import 'package:ecommerce_app/views/profile_screen/components/details_card.dart';
import 'package:ecommerce_app/views/profile_screen/edit_profile_screen.dart';
import 'package:ecommerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:ecommerce_app/widgets/background_widget.dart';
import 'package:ecommerce_app/widgets/loading_indicator.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

late ProfileController controller;

@override
void initState(){
  super.initState();
  controller=Get.put(ProfileController());
}

  @override
  Widget build(BuildContext context) {
   
   var userStream=FireStoreServices.getUser(auth.currentUser!.uid);

    return backgroundWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: userStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else if (snapshot.data!.docs.isNotEmpty) {
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Edit profile...
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.nameController.text = data['name'];
                            // Clear the text fields
                            controller.oldpassController.clear();
                            controller.newpassController.clear();
                            Get.to(() => EditProfileScreen(data: data));
                          },
                          child: const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                
                      // User details ...
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            data['imageUrl'] == ''
                                ? Image.asset(
                                    imgProfile2,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.network(
                                    data['imageUrl'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                            10.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['name']}",
                                    style: const TextStyle(
                                      fontFamily: semibold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${data['email']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: whiteColor),
                              ),
                              onPressed: () async {
                                await Get.put(AuthController())
                                    .signoutMethod(context);
                                Get.offAll(() => const LoginScreen());
                              },
                              child: const Text(
                                logout,
                                style: TextStyle(
                                  fontFamily: semibold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.heightBox,
                
                      FutureBuilder(
                          future: FireStoreServices.getCounts(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: loadingIndicator());
                            } else {
                              var countData = snapshot.data;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  detailsCard(
                                    count: countData[0].toString(),
                                    title: "in your cart",
                                    width: context.screenWidth / 3.4,
                                  ),
                                  detailsCard(
                                    count: countData[1].toString(),
                                    title: "in your wishlist",
                                    width: context.screenWidth / 3.4,
                                  ),
                                  detailsCard(
                                    count: countData[2].toString(),
                                    title: "your orders",
                                    width: context.screenWidth / 3.4,
                                  ),
                                ],
                              );
                            }
                          }),
                
                      // Buttons...
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: profileButtonsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Get.to(() => const OrderScreen());
                                  break;
                                case 1:
                                  Get.to(() => const WishlistScreen());
                                  break;
                                case 2:
                                  Get.to(() => const MessagesScreen());
                                  break;
                              }
                            },
                            leading: Image.asset(
                              profileButtonsIcon[index],
                              width: 22,
                            ),
                            title: Text(
                              profileButtonsList[index],
                              style: const TextStyle(
                                fontFamily: semibold,
                                color: darkFontGrey,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(color: lightGrey);
                        },
                      )
                          .box
                          .white
                          .rounded
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .shadow
                          .margin(const EdgeInsets.all(12))
                          .make()
                          .box
                          .color(redColor)
                          .make(),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
