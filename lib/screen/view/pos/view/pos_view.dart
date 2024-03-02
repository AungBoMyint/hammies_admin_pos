import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter/src/widgets/platform_menu_bar.dart' hide MenuItem;
import 'package:hammies_user/widgets/dashboard_menu/dashboard_menu.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/home_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/dashboard_menu/dashboard_menu.dart';
import '../../../../widgets/pos/button/button.dart';
import '../../../../widgets/search_bar/search_bar.dart';
import '../../pos_checkout/view/pos_checkout_view.dart';
import '../controller/pos_controller.dart';

class PosView extends StatelessWidget {
  const PosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return GetBuilder<PosController>(
      builder: (controller) {
        if (controller.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (controller.orderDetail == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(
                  child: Text(
                "Hammies  Mandalian  POS",
                style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 2,
                    wordSpacing: 2,
                    fontWeight: FontWeight.bold),
              )),
            ),
            body: DashboardMenu(
              items: [
                CustomMenuItem(
                  icon: FontAwesomeIcons.cashRegister,
                  label: "POS",
                  color: theme.primary,
                  onTap: () => controller.createNewOrder(),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.boxOpen,
                  label: "Sliders",
                  color: Colors.green,
                  onTap: () => Get.toNamed(sliderUrl),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.boxOpen,
                  label: "ကုန်ပစ္စည်းများ",
                  color: Colors.green,
                  onTap: () => Get.toNamed(productUrl),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.boxOpen,
                  label: "ဆုလာဘ်အတွက် ကုန်ပစ္စည်းများ",
                  color: Colors.green,
                  onTap: () => Get.toNamed(rewardProductUrl),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.boxes,
                  label: "ကုန်ပစ္စည်း အုပ်စုများ",
                  color: Colors.orange,
                  onTap: () => Get.toNamed(
                      productCategoryUrl), // Get.to(ProductCategoryView()),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.shoppingBag,
                  label: "အော်ဒါများ",
                  color: Colors.orange,
                  onTap: () => Get.toNamed(
                      userOrderUrl), // Get.to(ProductCategoryView()),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.dollarSign,
                  label: "အသုံးစရိတ် အုပ်စုများ",
                  color: Colors.orange,
                  onTap: () => Get.toNamed(
                      expendCategoryUrl), // Get.to(ProductCategoryView()),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.searchDollar,
                  label: "အသုံးစရိတ်",
                  color: Colors.orange,
                  onTap: () =>
                      Get.toNamed(expendUrl), // Get.to(ProductCategoryView()),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.boxes,
                  label: "ကုန်ပစ္စည်း စာရင်း",
                  color: Colors.purple,
                  onTap: () => Get.toNamed(inventoryUrl),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.chartBar,
                  label: "အရောင်း တိုးတက်မှု ဇယား",
                  color: Colors.purple,
                  onTap: () => Get.toNamed(salesUrl),
                ),
                CustomMenuItem(
                  icon: FontAwesomeIcons.phoneAlt,
                  label: "အကူအညီ",
                  color: Colors.blue,
                  onTap: () => {
                    launch("tel://09954055655"),
                  }, //Get.to(HelpView()),
                ),
              ],
            ),
            //   ],
            // ),
          );
        }
        //return const SizedBox(height: 0, width: 0);
        return Scaffold(
          //For pos order, product list to add to cart
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => {},
              icon: const Icon(
                FontAwesomeIcons.barcode,
                size: 30,
              ),
            ),
            title: const Text("POS"),
            centerTitle: true,
            actions: [
              //Search
              if (controller.search.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      controller.search = "";
                      controller.update();
                    },
                    child: Card(
                      color: theme.warning,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 4.0,
                          bottom: 4.0,
                        ),
                        child: Center(
                          child: Text(
                            "Search: ${controller.search}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SearchIcon(
                id: "product_search",
                onSearch: (search) {
                  log("Search : $search");
                  controller.search = search;
                  controller.update();
                },
              ),
              //Cart
              InkWell(
                onTap: () => controller.updateFilter("Your Order"),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: controller.categoryNameFilter == "Your Order"
                            ? theme.primary
                            : null,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Center(
                        child: Text(
                          controller.orderItems.isNotEmpty
                              ? "${controller.orderItems.length} items"
                              : "",
                          style: TextStyle(
                            fontSize: 11.0,
                            color: controller.categoryNameFilter == "Your Order"
                                ? theme.primary
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => controller.resetState(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
                  child: Icon(
                    Icons.cancel,
                    color: theme.primary,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              //Menu
              Container(
                height: 40.0,
                child: Obx(
                  () {
                    return Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView.builder(
                        itemCount: homeController.productCategoryList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var item = homeController.productCategoryList[index];

                          return Container(
                            child: Wrap(
                              children: [
                                if (index == 0)
                                  InkWell(
                                    onTap: () => controller.updateFilter("All"),
                                    child: Card(
                                      color:
                                          controller.categoryNameFilter == "All"
                                              ? theme.primary
                                              : Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "All",
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            color:
                                                controller.categoryNameFilter ==
                                                        "All"
                                                    ? Colors.white
                                                    : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                InkWell(
                                  onTap: () =>
                                      controller.updateFilter(item.category),
                                  child: Card(
                                    color: controller.categoryNameFilter ==
                                            item.category
                                        ? theme.primary
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item.category,
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color:
                                              controller.categoryNameFilter ==
                                                      item.category
                                                  ? Colors.white
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: homeController.items.length,
                      itemBuilder: (context, index) {
                        var item = homeController.items[index];

                        log("search >>> ${controller.search}");
                        if (controller.search.isNotEmpty &&
                            !item.name
                                .toString()
                                .toLowerCase()
                                .contains(controller.search.toLowerCase())) {
                          return Container();
                        }

                        if (controller.categoryNameFilter != "All" &&
                            controller.categoryNameFilter != "Your Order") {
                          if (item.category != controller.categoryNameFilter) {
                            return Container();
                          }
                        }

                        if ((controller.categoryNameFilter == "scanning") &&
                            (controller.barcodeResult == null)) {
                          return const Center(
                            child: Text("No product found!."),
                          );
                        }

                        if ((controller.categoryNameFilter == "scanning") &&
                            !(controller.barcodeResult == null) &&
                            (controller.barcodeResult != item.id)) {
                          return Container();
                        }

                        var searchList = controller.orderItems
                            .where((p) => p.id == item.id)
                            .toList();

                        var qty = 0;
                        if (searchList.isNotEmpty) {
                          var orderItem = searchList[0];
                          qty = orderItem.count!;

                          if (controller.categoryNameFilter == "Your Order") {
                            if (qty == 0) return Container();
                          }
                        }

                        if (controller.categoryNameFilter == "Your Order") {
                          if (qty == 0) return Container();
                        }
                        return Card(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: item.photo,
                                    height: 100,
                                    width: 90,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, status) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            value: status.progress,
                                          ),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 100.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Text(item.name),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(
                                          item.category,
                                          style: const TextStyle(
                                            fontSize: 8.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4.0,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "${item.price} ",
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () => (qty >=
                                                          item.remainQuantity ||
                                                      item.remainQuantity == 0)
                                                  ? null
                                                  : controller.addItemQty(item),
                                              child: CircleAvatar(
                                                backgroundColor: theme.disabled,
                                                radius: 12,
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 38.0,
                                              child: Center(
                                                child: Text(
                                                  "$qty",
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => controller
                                                  .subtractItemQty(item),
                                              child: CircleAvatar(
                                                backgroundColor: theme.disabled,
                                                radius: 12,
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (qty >= item.remainQuantity ||
                                            item.remainQuantity == 0) ...[
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            color: theme.primary,
                                            child: const Text("Out of order",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ],
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Container(
                color: theme.disabled,
                width: Get.width,
                padding: theme.normalPadding,
                child: Row(
                  children: [
                    Text(
                      "Total: ${controller.total.round()} ကျပ်",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    Spacer(),
                    ExButton(
                      color: ApplicationTheme().primary,
                      borderRadius: BorderRadius.circular(10),
                      label: "Checkout",
                      height: 40.0,
                      onPressed: () => Get.to(() => PosCheckoutView(
                            orderDetail: controller.orderDetail!,
                            orderItems: controller.orderItems,
                            total: controller.total,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
