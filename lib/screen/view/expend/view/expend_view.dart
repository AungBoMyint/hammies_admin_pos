import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import '../../../../controller/home_controller.dart';
import '../../../../utils/theme.dart';
import '../../../../utils/utils.dart';
import '../../expend_form/controller/expend_form_controller.dart';
import '../../expend_form/view/expend_form_view.dart';
import '../controller/expend_view_controller.dart';

class ExpendView extends StatefulWidget {
  const ExpendView({Key? key}) : super(key: key);

  @override
  State<ExpendView> createState() => _ExpendViewState();
}

class _ExpendViewState extends State<ExpendView> {
  @override
  void initState() {
    Get.put(ExpendViewController());
    Get.put(ExpendFormController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete();
    Get.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ExpendViewController _expendController = Get.find();
    final HomeController _homeController = Get.find();
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("အသုံးစရိတ်")),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Get.to(() => const ExpendFormView()),
        ),
        body: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Column(children: [
              GetBuilder<ExpendViewController>(builder: (controller) {
                return SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      //All
                      InkWell(
                        onTap: () => controller.changeFilter(Filter.all),
                        child: Card(
                          color: controller.filter == Filter.all
                              ? theme.primary
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "All",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: controller.filter == Filter.all
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //DateTime
                      InkWell(
                        onTap: () {
                          //need to change ui color
                          _expendController.changeFilter(Filter.date);
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2021, 1, 1),
                              maxTime: DateTime(2030, 12, 1),
                              onChanged: (date) {
                            //do nothing
                          }, onConfirm: (date) {
                            _expendController.confirmSelectedDate(date);
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Card(
                          color: controller.filter == Filter.date
                              ? theme.primary
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              controller.selectedDateString,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: controller.filter == Filter.date
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
              Expanded(child:
                  GetBuilder<ExpendViewController>(builder: (controller) {
                if (_homeController.expendList.isEmpty) {
                  return Center(
                      child: Text("You haven't added any expenditure yet!"));
                }
                return Obx(() {
                  return ListView.builder(
                    itemCount: _homeController.expendList.length,
                    itemBuilder: (context, index) {
                      var item = _homeController.expendList[index];

                      var selectedDate = DateFormat("ddMMMy").format(
                          DateTime.parse(
                              _expendController.selectedDate.toString()));
                      var itemDate = DateFormat("ddMMMy")
                          .format(DateTime.parse(item.dateTime));
                      if ((_expendController.filter == Filter.date) &&
                          (selectedDate != itemDate)) {
                        return Container();
                      }

                      return InkWell(
                          onTap: () {
                            Get.to(() => ExpendFormView(
                                  expend: item,
                                ));
                          },
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.all(6.0),
                              child: Container(
                                height: 100.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      DateFormat("EEEE, dd MMM y kk:mm").format(
                                          DateTime.parse(item.dateTime)),
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "${item.cost}ks",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ), //Container
                            ), //Card
                          )); //Inkwell
                    },
                  );
                }); //List view
              }))
            ])));
  }
}
