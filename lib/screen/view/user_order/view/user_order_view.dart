import 'package:flutter/material.dart';
import 'package:hammies_user/widgets/order/cash_on_delivery.dart';
import 'package:hammies_user/widgets/order/pre_pay.dart';

import '../../../../widgets/order/reward_order_only.dart';

class UserOrderView extends StatelessWidget {
  const UserOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          bottom: TabBar(
              unselectedLabelColor: Colors.grey.shade400,
              labelColor: Colors.grey.shade700,
              tabs: [
                Tab(
                  text: "Cash On Delivery",
                ),
                Tab(text: "Pre-Pay"),
                Tab(text: "Reward"),
              ]),
        ),
        body: TabBarView(children: [
          CashOnDelivery(),
          PrePay(),
          RewardOrderOnly(),
        ]),
      ),
    );
  }
}
