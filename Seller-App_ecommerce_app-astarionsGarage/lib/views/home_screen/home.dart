import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/home_controller.dart';
import 'package:ecommerce_seller_app/views/order_screen/orders_screen.dart';
import 'package:ecommerce_seller_app/views/products_screen/products_screen.dart';
import 'package:ecommerce_seller_app/views/profile_screen/profile_screen.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var bottomNavbarItem = [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProducts,
            width: 24,
            color: whiteColor,
          ),
          label: products),
      BottomNavigationBarItem(
          icon: Image.asset(
            icOrders,
            width: 24,
            color: whiteColor,
          ),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(
            icGeneralSettings,
            width: 24,
            color: whiteColor,
          ),
          label: settings),
    ];

    var navScreen = [
      const HomeScreen(),
      const ProductsScreen(),
      const OrdersScreen(),
      const ProfileScreen()
    ];
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.navIndex.value,
          backgroundColor: purpleColor,
          unselectedItemColor: whiteColor,
          iconSize: 30.0,
          selectedFontSize: 15.0,
          unselectedFontSize: 13.0,
          selectedItemColor: Colors.yellow,
          selectedLabelStyle: const TextStyle(fontFamily: "bold"),
          type: BottomNavigationBarType.fixed,
          items: bottomNavbarItem,
          onTap: (value) {
            controller.navIndex.value = value;
          },
        ),
      ),
      backgroundColor: bgColor,
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreen.elementAt(controller.navIndex.value))
          ],
        ),
      ),
    );
  }
}
