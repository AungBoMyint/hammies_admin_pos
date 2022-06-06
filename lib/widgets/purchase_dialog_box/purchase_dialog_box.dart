import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Condition;
import 'package:hammies_user/screen/view/order_print/view/user_order_print_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../controller/home_controller.dart';
import '../../data/constant.dart';
import '../../model/real_purchase.dart';

Widget purchaseDialogBox({
  required int i,
  required int total,
  required int shipping,
  required String township,
  required List<PurchaseModel> list,
  required BuildContext context,
}) {
  HomeController controller = Get.find();
  final responsiveFontSize14 = TextStyle(
    fontSize: ResponsiveValue(context, 
    defaultValue: 12.0, 
    valueWhen: [
      Condition.smallerThan(
        name: DESKTOP,
        value: 10.0,
      )
    ],
    ).value,
  );
  final responsiveFontSize10 = TextStyle(
    fontSize: ResponsiveValue(context, 
    defaultValue: 10.0, 
    valueWhen: [
      Condition.smallerThan(
        name: DESKTOP,
        value: 6.0,
      )
    ],
    ).value,
  );
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text("Purchase Date"),
          Text(
            "၀ယ်ယူခဲ့သော နေ့ရက် - ${DateTime.tryParse(list[i].dateTime)?.day}/${DateTime.tryParse(list[i].dateTime)?.month}/${DateTime.tryParse(list[i].dateTime)?.year}",
            style: responsiveFontSize14,
          ),
        ],
      ),
      SizedBox(
        height: 15,
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text("Name"),
          Text(
            list[i].name,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text("Ph No."),
          Text(
            "0${list[i].phone}",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text("Email"),
          Text(
            list[i].email,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),

      SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text("Address"),
          Expanded(
              child: Text(
            list[i].address,
            style: TextStyle(fontSize: 14),
          )),
        ],
      ),
      SizedBox(
        height: 25,
      ),
      Container(
        width: 400,
        height: 150,
        child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: list[i].items!.length,
            itemBuilder: (_, o) {
              final purchase = list[i].items![o];
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${o + 1}. ${purchase.itemName}",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${purchase.color}",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            "${purchase.size}",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "${purchase.price} x  ${purchase.count} ထည်",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            }),
      ),
      //Delivery Township
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ပို့ဆောင်ရမည့်မြို့နယ် -",
            style: responsiveFontSize14,
          ),
          //SizedBox(width: 10),
          Text(
            township,
            style: TextStyle(fontSize:  ResponsiveValue(context, 
    defaultValue: 14.0, 
    valueWhen: [
      Condition.smallerThan(
        name: DESKTOP,
        value: 10.0,
      )
    ],
    ).value, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "စုစုပေါင်း",
            style: responsiveFontSize14,
          ),
          Text(
            "$total + Deli $shipping Ks",
            style: responsiveFontSize14,
          ),
        ],
      ),
      const SizedBox(height: 10,),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: homeIndicatorColor,
        ),
            onPressed: () {
              //Show BlueTooth Dialog..Box....
              Get.to(UserOrderPrintView(
                purchaseModel: list[i], 
                total: total, 
                shipping: shipping, 
                township: township,));
            },
            child: Text("See As Photo"),
          ),
    ],
  );
}
