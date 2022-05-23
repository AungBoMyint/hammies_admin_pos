import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final Function onTap;

  MenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class DashboardMenu extends StatelessWidget {
  final List<MenuItem> items;
  final double horizontalPadding;
  DashboardMenu({
    this.items = const [],
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    var itemWidth = (Get.width / 5) - horizontalPadding;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      width: Get.width,
      child: Wrap(
        // runSpacing: 10.0,
        // spacing: 10.0,
        // crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        // runAlignment: WrapAlignment.center,

        children: [
          ...List.generate(items.length, (index) {
            var item = items[index];
            return InkWell(
              onTap: () => item.onTap(),
              child: Container(
                width: itemWidth,
                height: itemWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Icon(
                      item.icon,
                      color: item.color,
                      size: 100,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: item.color,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
            );
          }),
          // InkWell(
          //   // onTap: () => controller.createNewOrder(),
          //   child: Container(
          //     width: 40.0,
          //     height: 40.0,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.network(
          //           "https://icons.iconarchive.com/icons/flat-icons.com/square/128/cashier-icon.png",
          //           height: 50,
          //           width: 50,
          //         ),
          //         SizedBox(
          //           height: 2.0,
          //         ),
          //         Text("Pos"),
          //       ],
          //     ),
          //   ),
          // ),
          // InkWell(
          //   // onTap: () => Get.to(ProductView()),
          //   child: Container(
          //     width: 40.0,
          //     height: 40.0,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.network(
          //           "https://icons.iconarchive.com/icons/custom-icon-design/flatastic-2/128/product-icon.png",
          //           height: 50,
          //           width: 50,
          //         ),
          //         SizedBox(
          //           height: 2.0,
          //         ),
          //         Text("Product"),
          //       ],
          //     ),
          //   ),
          // ),
          // InkWell(
          //   // onTap: () => Get.to(ProductView()),
          //   child: Container(
          //     width: 40.0,
          //     height: 40.0,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.network(
          //           "https://icons.iconarchive.com/icons/custom-icon-design/flatastic-2/128/product-icon.png",
          //           height: 50,
          //           width: 50,
          //         ),
          //         SizedBox(
          //           height: 2.0,
          //         ),
          //         Text("Product Category"),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
