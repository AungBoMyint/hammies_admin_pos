import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../model/product_item.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/pos/button/button.dart';
import '../../../../widgets/textfield/row_textfield.dart';
import '../../../../widgets/textfield/textfield_format.dart';
import '../controller/pos_checkout_controller.dart';

class PosCheckoutView extends StatelessWidget {
  final Map<String, dynamic> orderDetail;
  final List<ProductItem> orderItems;
  final double total;

  PosCheckoutView({
    Key? key,
    required this.orderDetail,
    required this.orderItems,
    required this.total,
  }) : super(key: key);

  final controller = Get.put(PosCheckoutController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PosCheckoutController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("Checkout")),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      var item = orderItems[index];

                      return Card(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
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
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Container(
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            "${item.price} ကျပ်",
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            width: 38.0,
                                            child: Center(
                                              child: Text(
                                                "x ${item.count}",
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                width: Get.width,
                child: Column(
                  children: [
                    ExRowTextField(
                      id: "pay",
                      label: "Pay",
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      format: TextFieldFormat.money,
                      value: total.toString(),
                      onSubmitted: (value) => controller.onInputValue(total),
                      onChanged: (value) => {}, //controller.onInputValue(),
                    ),
                    ExRowTextField(
                      onChanged: (value) {},
                      id: "change",
                      label: "Change",
                      textAlign: TextAlign.right,
                      format: TextFieldFormat.money,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      value: "0".toString(),
                      onSubmitted: (value) => {}, //controller.onInputValue(),
                    ),
                  ],
                ),
              ),
              Container(
                color: theme.disabled,
                width: Get.width,
                padding: theme.normalPadding,
                child: Row(
                  children: [
                    Text(
                      "Total: $total ks",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(
                      width: 100.0,
                    ),
                    Expanded(
                      child: ExButton(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(10),
                        label: "Save",
                        height: 40.0,
                        onPressed: () => controller.save(
                            orderDetail, orderItems, total.round()),
                      ),
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
