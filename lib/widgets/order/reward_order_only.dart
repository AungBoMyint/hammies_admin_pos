import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hammies_user/controller/home_controller.dart';
import 'package:hammies_user/widgets/purchase_dialog_box/reward_purchase_dialog.dart';


class RewardOrderOnly extends StatelessWidget {
  const RewardOrderOnly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find();
    return ListView.builder(
      itemCount: controller.getRewardOrderOnly().length,
      itemBuilder: (_, i) {
        List town = controller.getRewardOrderOnly()[i].deliveryTownshipInfo;
        final shipping = town[1];
        final townName = town[0];
        return ListTile(
          title: Text(
              "${controller.getRewardOrderOnly()[i].name} 0${controller.getRewardOrderOnly()[i].phone}"),
          subtitle: Text(
              "${DateTime.parse(controller.getRewardOrderOnly()[i].dateTime).day}/${DateTime.parse(controller.getRewardOrderOnly()[i].dateTime).month}/${DateTime.parse(controller.getRewardOrderOnly()[i].dateTime).year}"),
          trailing: IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Customer ၀ယ်ယူခဲ့သော အချက်အလက်များ",
                titleStyle: TextStyle(fontSize: 12),
                radius: 5,
                content: rewardPurchaseDialogBox(
                  context: context,
                    i: i,
                    total: 0,
                    shipping: shipping,
                    township: townName,
                    list: controller.getRewardOrderOnly(),),
              );
            },
            icon: Icon(Icons.info),
          ),
        );
      },
    );
  }
}
