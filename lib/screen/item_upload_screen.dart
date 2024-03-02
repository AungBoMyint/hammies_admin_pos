import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hammies_user/utils/utils.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../controller/home_controller.dart';
import '../controller/upload_controller.dart';
import '../data/constant.dart';
import '../utils/theme.dart';
import '../widgets/pos/button/button.dart';
import '../widgets/radio/stream_radio.dart';

class UploadItem extends StatefulWidget {
  const UploadItem({Key? key}) : super(key: key);

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  final HomeController homecontroller = Get.find();

  @override
  void initState() {
    Get.put(UploadController());
    super.initState();
  }

  @override
  void dispose() {
    homecontroller.setEditItem(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UploadController controller = Get.find();
    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        title: const Center(child: Text("ကုန်ပစ္စည်း ပုံစံ")),
        actions: [
          if (!(homecontroller.editItem.value == null)) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 12.0,
              ),
              child: ExButton(
                color: ApplicationTheme().primary,
                label: "Delete",
                onPressed: () =>
                    controller.delete(homecontroller.editItem.value!.id),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ExButton(
              color: ApplicationTheme().primary,
              label: "Save",
              onPressed: () => controller.upload(),
            ),
          ),
        ],
      ),
      body: Form(
        key: controller.form,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.photoController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Photo Link',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.photo2Controller,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Photo Link 2',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.photo3Controller,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Photo Link 3',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.nameController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'Product အမည်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                // textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: null,

                controller: controller.descController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အသေးစိတ်ဖော်ပြချက်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            20.v(),
            //COLORS
            SizedBox(
              height: 35,
              child: InkWell(
                onTap: () => colorPickerDialog(context),
                child: Row(
                  children: [
                    20.h(),
                    Icon(
                      FontAwesomeIcons.plus,
                      color: homeIndicatorColor,
                    ),
                    20.h(),
                    Text("Pick Color(mandatory)"),
                  ],
                ),
              ),
            ),

            Obx(() {
              final colorController = controller.colorController;
              if (colorController.isNotEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Wrap(
                    children: colorController
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                height: 16 * 2,
                                width: 16 * 2,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor:
                                          Color(int.tryParse(e) ?? 0),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          onTap: () {
                                            controller.colorController
                                                .remove(e);
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.minus,
                                            color: Colors.black,
                                            size: 10,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              } else {
                return 0.h();
              }
            }),
            //SIZE
            20.v(),
            //COLORS
            SizedBox(
              height: 35,
              child: InkWell(
                onTap: () => controller.addSize(),
                child: Row(
                  children: [
                    20.h(),
                    Icon(
                      FontAwesomeIcons.plus,
                      color: homeIndicatorColor,
                    ),
                    20.h(),
                    Text("Add Size(mandatory)"),
                  ],
                ),
              ),
            ),

            Obx(() {
              final sizeController = controller.sizeController;
              if (sizeController.isNotEmpty) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Wrap(
                      children: List.generate(sizeController.length, (index) {
                        final e = sizeController[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 0),
                          child: SizedBox(
                              height: 80,
                              child: Row(
                                children: [
                                  //Size
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: e.size,
                                      // textInputAction: TextInputAction.done,
                                      onChanged: (v) =>
                                          controller.changeSizeText(v, index),
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      minLines: 1,
                                      maxLines: null,
                                      validator: controller.validator,
                                      decoration: InputDecoration(
                                        hintText: 'Size',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  20.h(),
                                  //Price
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: e.price.toString(),
                                      // textInputAction: TextInputAction.done,
                                      onChanged: (v) =>
                                          controller.changeSizePrice(v, index),
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      minLines: 1,
                                      maxLines: null,
                                      validator: controller.validator,
                                      decoration: InputDecoration(
                                        hintText: 'Price',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  20.h(),
                                  InkWell(
                                      onTap: () {
                                        controller.removeSize(index);
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.minus,
                                        color: Colors.black,
                                        size: 10,
                                      )),
                                ],
                              )),
                        );
                      }).toList(),
                    ));
              } else {
                return 0.h();
              }
            }),

            /* Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.colorController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အရောင်',
                  border: OutlineInputBorder(),
                ),
              ),
            ), */
            /* Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.sizeController,
                validator: controller.validator,
                decoration: InputDecoration(
                  hintText: 'အရွယ်အစား',
                  border: OutlineInputBorder(),
                ),
              ),
            ), */
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.starController,
                validator: controller.validator,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Star',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.originalPriceController,
                validator: controller.validator,
                decoration: const InputDecoration(
                  hintText: '၀ယ်စျေး',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.priceController,
                validator: controller.validator,
                decoration: const InputDecoration(
                  hintText: 'ရောင်းစျေး',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.discountPriceController,
                validator: controller.validator,
                decoration: const InputDecoration(
                  hintText: 'လျော့စျေး(optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //Quantity
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.originalQuantityController,
                validator: controller.validator,
                decoration: const InputDecoration(
                  hintText: 'မူလကုန်အရေအတွက်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //RemainQuantity
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: controller.remainQuantityController,
                validator: controller.validator,
                decoration: const InputDecoration(
                  hintText: 'ကျန်ကုန်အရေအတွက်',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //Category
            ExStreamRadio(
              id: "category_name",
              label: "Category",
              valueField: "category_name",
              labelField: "category_name",
              categoryList: homecontroller.productCategoryList,
              keyboardType: TextInputType.text,
              onChanged: (value) => controller.categoryController.text = value,
              value: homecontroller.editItem.value?.category ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
