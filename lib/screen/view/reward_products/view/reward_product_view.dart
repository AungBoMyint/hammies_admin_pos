import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hammies_user/screen/view/reward_product_form/view/reward_product_form.dart';
import 'package:hammies_user/screen/view/reward_products/controller/reward_controller.dart';

import '../../../../controller/home_controller.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/search_bar/search_bar.dart';

class RewardProductView extends StatefulWidget {
  const RewardProductView({Key? key}) : super(key: key);

  @override
  State<RewardProductView> createState() => _RewardProductViewState();
}

class _RewardProductViewState extends State<RewardProductView> {
  @override
  void initState() {
    Get.put(RewardController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    return GetBuilder<RewardController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () {
            controller.search = "";
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("ဆုလာဘ်အတွက် ကုန်ပစ္စည်းများ")),
              actions: [
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
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Get.to(RewardProductForm());
              },
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  // Obx(() {
                  //   return ExStreamRadio(
                  //     value: "",
                  //     keyboardType: TextInputType.none,
                  //     id: "category_name_filter",
                  //     label: "Category",
                  //     valueField: "category_name",
                  //     labelField: "category_name",
                  //     categoryList:  homeController.productCategoryList.value,
                  //     onChanged: (value) {
                  //       controller.categoryNameFilter = value;
                  //       controller.update();
                  //     },
                  //   );
                  // }),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: homeController.rewardItems.length,
                        itemBuilder: (context, index) {
                          var item = homeController.rewardItems[index];
                          // if (controller.categoryNameFilter != null) {
                          //   if (item.category !=
                          //       controller.categoryNameFilter) {
                          //     return Container();
                          //   }
                          // }

                          log("search >>> ${controller.search}");
                          if (controller.search.isNotEmpty &&
                              !item.name.toString().toLowerCase().contains(
                                  controller.search.toLowerCase())) {
                            return Container();
                          }
                          debugPrint("*****Image: ${item.image}");

                          return InkWell(
                            onTap: () {
                              Get.to(RewardProductForm(
                                rewardProduct: item,
                              ));
                            },
                            child: Card(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: item.image,
                                      height: 100,
                                      width: 100.0,
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
                                            Text(item.name),
                                            // const SizedBox(
                                            //   height: 4.0,
                                            // ),
                                            // Text(
                                            //   item.category,
                                            //   style: const TextStyle(
                                            //     fontSize: 8.0,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text(
                                              "${item.requirePoint} points",
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
