import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hammies_user/model/app_slider.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/home_controller.dart';
import '../../../model/pos/expend_category.dart';
import '../../../utils/theme.dart';
import '../../../widgets/pos/button/button.dart';
import '../../../widgets/pos/input/input.dart';
import '../../../widgets/textfield/textfield.dart';

class AppSliderView extends StatelessWidget {
  const AppSliderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find();
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Sliders")),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: ExTextField(
                        id: "image",
                        label: "Photo Link",
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                        height: 90,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: ExButton(
                        color: theme.primary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        label: "Add",
                        height: 36.0,
                        onPressed: () {
                          _homeController.addSldier(
                              slider: AppSlider(
                                  id: Uuid().v1(),
                                  image:
                                      textFieldController["image"]?.text ?? "",
                                  dateTime: DateTime.now()));
                          textFieldController["category_name"]?.text = "";
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(
                  () {
                    if (_homeController.sliders.isEmpty) {
                      return const Center(
                          child: Text(
                        "No sliders yet....",
                      ));
                    }

                    return ListView.builder(
                      itemCount: _homeController.sliders.length,
                      itemBuilder: (context, index) {
                        var item = _homeController.sliders[index];

                        return InkWell(
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
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
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      await _homeController.deleteSlider(
                                          pathID: item.id);
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.0,
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
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
