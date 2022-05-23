import 'package:get/get.dart';
import 'package:hammies_user/screen/view/product/view/product_view.dart';
import 'package:hammies_user/screen/view/reward_products/view/reward_product_view.dart';
import 'package:hammies_user/screen/view/user_order/view/user_order_view.dart';

import '../controller/home_controller.dart';
import '../screen/view/expend/view/expend_view.dart';
import '../screen/home_screen.dart';
import '../screen/item_upload_screen.dart';
import '../screen/view/auth/login/view/login_view.dart';
import '../screen/view/expend_category/expend_category_view.dart';
import '../screen/view/pos_inventory/inventory_management.dart';
import '../screen/view/pos_sales_analysis/sales_analysis.dart';
import '../screen/view/product_category/product_category_view.dart';

const String homeScreen = '/home';
const String checkOutScreen = '/checkout';
const String detailScreen = '/detail';
const String uploadItemScreen = '/uploadItemScreen';
const String mangeItemScreen = '/manage-item';
const String purchaseScreen = '/purchase-screen';
const String blueToothScreen = '/bluetooth-screen';
const String searchScreen = '/searchScreen';
const posUrl = "/pos_url";
const loginUrl = "/login_url";
const salesUrl = "/sales_url";
const inventoryUrl = "/inventory_url";
const couponUrl = "/coupon_url";
const expendCategoryUrl = "/expend_category_url";
const expendUrl = "/expend_url";
const productCategoryUrl = "/product_category_url";
const orderPrintUrl = "/order_print";
const rewardProductUrl = "/reward_product_view";
const productUrl = "/product_view";
const userOrderUrl = "/user_orders";

List<GetPage> routes = [
  GetPage(
    name: homeScreen,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: uploadItemScreen,
    page: () => UploadItem(),
  ),
  GetPage(
    name: productUrl,
    page: () => ProductView(),
  ),
  GetPage(
    name: rewardProductUrl,
    page: () => RewardProductView(),
  ),
  GetPage(
    name: inventoryUrl,
    page: () => const InventoryManagement(),
  ),
  GetPage(
    name: salesUrl,
    page: () => const SalesAnalysis(),
  ),
  GetPage(
    name: userOrderUrl,
    page: () => const UserOrderView(),
  ),
  GetPage(
    name: loginUrl,
    page: () => const LoginView(),
  ),
  GetPage(
    name: expendCategoryUrl,
    page: () => const ExpendCategoryView(),
  ),
  GetPage(
    name: expendUrl,
    page: () => const ExpendView(),
  ),
  GetPage(
    name: productCategoryUrl,
    page: () => const ProductCategoryView(),
  ),
];

final HomeController controller = Get.find();
String checkAuthenticateAndRedirect() {
  return controller.user.value == null ? loginUrl : homeScreen;
}
