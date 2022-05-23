import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hammies_user/controller/upload_controller.dart';
import 'package:hammies_user/model/reward_product.dart';
import 'package:hammies_user/widgets/pos/input/input.dart';
import 'package:hammies_user/widgets/textfield/textfield.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/constant.dart';
import '../../../../utils/theme.dart';
import '../../../../widgets/pos/button/button.dart';

class RewardProductForm extends StatefulWidget {
  final RewardProduct? rewardProduct;
  const RewardProductForm({Key? key, this.rewardProduct}) : super(key: key);

  @override
  State<RewardProductForm> createState() => _RewardProductFormState();
}

class _RewardProductFormState extends State<RewardProductForm> {
  @override
  void initState() {
    Get.put(UploadController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UploadController _uploadController = Get.find();
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        title: const Center(child: Text("ဆုလာဘ်အတွက် ကုန်ပစ္စည်း ပုံစံ")),
        actions: [
          if (!(widget.rewardProduct == null)) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 12.0,
              ),
              child: ExButton(
                  color: ApplicationTheme().primary,
                  label: "Delete",
                  onPressed: () => _uploadController
                      .deleteRewardProduct(widget.rewardProduct?.id ?? "")
                  //TODO: TO DELETE,
                  ),
            ),
          ],
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: ExButton(
                color: ApplicationTheme().primary,
                label: "Save",
                onPressed: () => _uploadController.saveRewardProduct(
                  RewardProduct(
                    id: widget.rewardProduct?.id ?? Uuid().v1(),
                    name: Input.get("name"),
                    image: Input.get("image"),
                    description: Input.get("description") ?? null,
                    requirePoint: int.tryParse(Input.get("point")) ?? 0,
                  ),
                ),
              )),
        ],
      ),
      body: ListView(
        children: [
          //Name
          ExTextField(
            id: "name",
            label: "Name",
            value: widget.rewardProduct?.name ?? "",
            keyboardType: TextInputType.text,
            onChanged: (value) {},
            onSubmitted: (value) {},
            height: 90,
          ),
          //Description
          ExTextField(
            id: "description",
            label: "Description (optional)",
            value: widget.rewardProduct?.description ?? "",
            keyboardType: TextInputType.text,
            onChanged: (value) {},
            onSubmitted: (value) {},
            height: 90,
          ),
          //Image Path
          ExTextField(
            id: "image",
            label: "Image",
            value: widget.rewardProduct?.image ?? "",
            keyboardType: TextInputType.text,
            onChanged: (value) {},
            onSubmitted: (value) {},
            height: 90,
          ),
          //Reward Point
          ExTextField(
            id: "point",
            label: "Require Point",
            value: widget.rewardProduct?.requirePoint == null
                ? "0"
                : "${widget.rewardProduct?.requirePoint}",
            keyboardType: TextInputType.number,
            onChanged: (value) {},
            onSubmitted: (value) {},
            height: 90,
          ),
        ],
      ),
    );
  }
}
