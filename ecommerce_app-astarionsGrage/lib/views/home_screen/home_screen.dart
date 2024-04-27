import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/category_screen/item_details.dart';
import 'package:ecommerce_app/views/home_screen/components/featured_button.dart';
import 'package:ecommerce_app/views/home_screen/search_screen.dart';
import 'package:ecommerce_app/widgets/dismiss_keyboard_on_tap.dart';
import 'package:ecommerce_app/widgets/home_buttons.dart';
import 'package:get/get.dart';

import '../../widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return DismissKeyboardOnTap(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: lightGrey,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search).onTap(() {
                    if(controller.searchController.text.isNotEmptyAndNotNull)
                    {Get.to(() => SearchScreen(
                          title: controller.searchController.text,
                        ));}
                        else{
                          VxToast.show(context, msg: "Write some keyword then search.",
                          position : VxToastPosition.top,bgColor:Vx.black,textColor: whiteColor,textSize: 18
                          ,pdHorizontal:10,pdVertical:10 );
                        }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  hintStyle: TextStyle(color: textfieldGrey),
                ),
              ),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //Swiper brands...

                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        itemCount: slidersList.length,
                        enlargeCenterPage: true,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            slidersList[index],
                            fit: BoxFit.cover,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          2,
                          (index) => homeButtons(
                                height: context.screenHeight * 0.15,
                                width: context.screenWidth / 2.5,
                                icon: index == 0 ? icTodaysDeal : icFlashDeal,
                                title: index == 0 ? todayDeal : flashSale,
                              )),
                    ),
                    10.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        itemCount: secondSlidersList.length,
                        enlargeCenterPage: true,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSlidersList[index],
                            fit: BoxFit.cover,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (index) => homeButtons(
                                height: context.screenHeight * 0.15,
                                width: context.screenWidth / 3.5,
                                icon: index == 0
                                    ? icTopCategories
                                    : index == 1
                                        ? icBrands
                                        : icTopSeller,
                                title: index == 0
                                    ? topCategory
                                    : index == 1
                                        ? brand
                                        : topSellers,
                              )),
                    ),

                    //Featured categories...

                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    10.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            3,
                            (index) => Column(
                                  children: [
                                    featuredButton(
                                        icon: featuredImages1[index],
                                        title: featuredTitles1[index]),
                                    10.heightBox,
                                    featuredButton(
                                        icon: featuredImages2[index],
                                        title: featuredTitles2[index]),
                                  ],
                                )).toList(),
                      ),
                    ),

                    //Featured products...

                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: redColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FireStoreServices.getFeaturedProducts(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: loadingIndicator());
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "No featured products"
                                      .text
                                      .white
                                      .makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                      children: List.generate(
                                    featuredData.length,
                                    (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 150,
                                            height: 130,
                                            fit: BoxFit.cover),
                                        10.heightBox,
                                        "${featuredData[index]['p_name']}"
                                            .text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "${featuredData[index]['p_price']}"
                                            .numCurrency
                                            .text
                                            .fontFamily(bold)
                                            .size(16)
                                            .color(redColor)
                                            .make(),
                                      ],
                                    )
                                        .box
                                        .white
                                        .rounded
                                        .padding(const EdgeInsets.all(8))
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .roundedSM
                                        .make()
                                        .onTap(() {
                                      Get.to(() => ItemDetails(
                                            title:
                                                "${featuredData[index]['p_name']}",
                                            data: featuredData[index],
                                          ));
                                    }),
                                  ));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Swiper

                    10.heightBox,

                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        itemCount: slidersList.length,
                        enlargeCenterPage: true,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            slidersList[index],
                            fit: BoxFit.cover,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),

                    //All products section....

                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: allProducts.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    10.heightBox,
                    StreamBuilder(
                        stream: FireStoreServices.allproducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var allproductsdata = snapshot.data!.docs;

                            return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allproductsdata.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        mainAxisExtent: 230),
                                itemBuilder: (context, index) {
                                  return Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                          allproductsdata[index]['p_imgs'][0],
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover),
                                      const Spacer(),
                                      "${allproductsdata[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "${allproductsdata[index]['p_price']}"
                                          .text
                                          .fontFamily(bold)
                                          .size(16)
                                          .color(redColor)
                                          .make(),
                                    ],
                                  )
                                      .box
                                      .white
                                      .roundedSM
                                      .outerShadowLg
                                      .padding(const EdgeInsets.all(12))
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .make()
                                      .onTap(() {
                                    Get.to(() => ItemDetails(
                                          title:
                                              "${allproductsdata[index]['p_name']}",
                                          data: allproductsdata[index],
                                        ));
                                  });
                                });
                          }
                        }),
                    30.heightBox,
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
