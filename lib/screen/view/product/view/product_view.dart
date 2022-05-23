import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/radio/stream_radio.dart';
import '../../../../widgets/search_bar/search_bar.dart';
import '../controller/product_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    Get.put(ProductController());
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
    return GetBuilder<ProductController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () {
            controller.search = "";
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("ကုန်ပစ္စည်းများ")),
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
                Get.toNamed(uploadItemScreen);
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
                  Obx(() {
                    return ExStreamRadio(
                      value: "",
                      keyboardType: TextInputType.none,
                      id: "category_name_filter",
                      label: "Category",
                      valueField: "category_name",
                      labelField: "category_name",
                      categoryList:  homeController.productCategoryList.value,
                      onChanged: (value) {
                        controller.categoryNameFilter = value;
                        controller.update();
                      },
                    );
                  }),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: homeController.items.length,
                        itemBuilder: (context, index) {
                          var item = homeController.items[index];
                          if (controller.categoryNameFilter != null) {
                            if (item.category !=
                                controller.categoryNameFilter) {
                              return Container();
                            }
                          }

                          if (controller.search != null) {
                            log("search >>> ${controller.search}");
                            if (controller.search.isNotEmpty &&
                                !item.name
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        controller.search.toLowerCase())) {
                              return Container();
                            }
                          }

                          return InkWell(
                            onTap: () {
                              homeController.setEditItem(item);
                              //Make Sure to change Brand Options Depend On This Product.
                              Get.toNamed(uploadItemScreen);
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
                                      imageUrl: item.photo,
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
                                            Text(
                                              "${item.price}ks",
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
