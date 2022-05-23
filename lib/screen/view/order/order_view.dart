import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controller/home_controller.dart';
import '../../../controller/pos/order_controller.dart';
import '../../../utils/theme.dart';
import '../../../widgets/pos/row_item.dart';
import '../order_print/view/order_print_view.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text(
          "Order List",
        ),
      )),
      body: Padding(
        padding: theme.normalPadding,
        child: Column(
          children: [
            GetBuilder<OrderController>(builder: (controller) {
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => controller.updateFilter(0),
                      child: Card(
                        color: controller.selectedFilterIndex == 0
                            ? theme.primary
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Today",
                            style: TextStyle(
                              color: controller.selectedFilterIndex == 0
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.updateFilter(1),
                      child: Card(
                        color: controller.selectedFilterIndex == 1
                            ? theme.primary
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Yesterday",
                            style: TextStyle(
                              color: controller.selectedFilterIndex == 1
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.updateFilter(2),
                      child: Card(
                        color: controller.selectedFilterIndex == 2
                            ? theme.primary
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "All",
                            style: TextStyle(
                              color: controller.selectedFilterIndex == 2
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
            }),
            Expanded(
              child: GetBuilder<OrderController>(builder: (controller) {
                if (_homeController.orderItemList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _homeController.orderItemList.length,
                    itemBuilder: (context, index) {
                      var item = _homeController.orderItemList[index];
                      var currentDate = DateFormat("ddMMMy")
                          .format(DateTime.parse(item.dateTime));
                      var today = DateFormat("ddMMMy").format(DateTime.now());
                      var yesterday = DateFormat("ddMMMy")
                          .format(DateTime.now().subtract(Duration(days: 1)));

                      if (controller.filterStatus == "Today") {
                        if (currentDate != today) {
                          return Container();
                        }
                      } else if (controller.filterStatus == "Yesterday") {
                        if (currentDate != yesterday) {
                          return Container();
                        }
                      }

                      return Container(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                /* Get.to(() => OrderDetailView(
                                      productList: item.itemIdList,
                                      total: item.total,
                                      pay: item.pay,
                                      item: item,
                                    ));*/
                                Get.to(() => OrderPrintView(
                                      orderItem: item,
                                    ));
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          QrImage(
                                            data: item.orderID,
                                            version: QrVersions.auto,
                                            size: 50.0,
                                          ),
                                          const Spacer(),
                                          Card(
                                            color: theme.primary,
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                top: 4.0,
                                                left: 4.0,
                                                right: 4.0,
                                                bottom: 4.0,
                                              ),
                                              child: Text(
                                                DateFormat(
                                                        "EEEE, dd MMM y kk:mm")
                                                    .format(DateTime.parse(
                                                        item.dateTime)),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: theme.primary,
                                      ),
                                      RowItem(
                                        label: "Order ID",
                                        value: item.orderID,
                                      ),
                                      RowItem(
                                        label: "Total",
                                        value: "${item.total}",
                                      ),
                                      RowItem(
                                        label: "Pay",
                                        value: "${item.pay}",
                                      ),
                                      RowItem(
                                        label: "Change",
                                        value: "${item.change}",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No order yet....",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
