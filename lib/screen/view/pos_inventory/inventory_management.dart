import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Condition;
import 'package:responsive_framework/responsive_framework.dart';

import '../../../controller/home_controller.dart';
import '../../../widgets/pos/inventory_widget/data_row.dart';
import '../../../widgets/pos/inventory_widget/inventory_piechart.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({Key? key}) : super(key: key);

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  @override
  Widget build(BuildContext context) {
    HomeController _controller = Get.find();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.indigo),
          title: const Text(
            "Stock Management",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                wordSpacing: 2,
                letterSpacing: 1),
          ),
          leading: const BackButton(color: Colors.black),
          centerTitle: true,
          /*actions: [
            IconButton(
                onPressed: () {
                
                  Get.toNamed(uploadItemScreen);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ))
          ],*/
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: ResponsiveRowColumn(
              rowMainAxisAlignment: MainAxisAlignment.start,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              rowPadding: const EdgeInsets.only(
                left: 20,
              ),
              //rowMainAxisAlignment: MainAxisAlignment.center,
              //columnCrossAxisAlignment: CrossAxisAlignment.start,
              layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              children: [
                const ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: InventoryPieChart(),
                ),
                ResponsiveRowColumnItem(
                  rowFlex: 4,
                  child: ResponsiveConstraints(
                    constraintsWhen: [
                      Condition.smallerThan(
                          name: DESKTOP,
                          value: BoxConstraints(
                            maxHeight: size.height * 0.6,
                          ))
                    ],
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                         Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Center(
                              child: Text(
                                "Stock Table",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 15, 70, 17),
                                  fontSize: ResponsiveValue(Get.context!, 
                              defaultValue: 18.0, 
                              valueWhen: [
                                Condition.smallerThan(
                                  name: DESKTOP,
                                  value: 14.0,
                                )
                              ],
                              ).value,
                                  wordSpacing: 1,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border: TableBorder.all(color: Colors.black),
                            headingTextStyle:  TextStyle(
                              fontSize: ResponsiveValue(context, 
                              defaultValue: 16.0, 
                              valueWhen: [
                                Condition.smallerThan(
                                  name: DESKTOP,
                                  value: 12.0,
                                )
                              ],
                              ).value,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            showCheckboxColumn: false,
                            columns: <DataColumn>[
                              //DataColumn(label: customTableCell("Function")),
                            
                              DataColumn(label: customTableCell("Name")),
                              DataColumn(
                                  label: customTableCell("Total Quantity")),
                              DataColumn(
                                  label: customTableCell("Remain Quantity")),
                              DataColumn(label: customTableCell("Selling Price")),
                              DataColumn(label: customTableCell("Selling Price Total")),
                              DataColumn(label: customTableCell("Buying Price")),
                              DataColumn(label: customTableCell("Buying Price Total")),
                              DataColumn(label: customTableCell("Code")),
                            ],
                            rows: [
                              for (var item in _controller.items) ...[
                                resuableDataRow(item: item),
                              ],
                              DataRow(
                                cells: [
                                  DataCell(customTableCell("TOTAL")),
                                  DataCell(customTableCell("")),
                                  DataCell(customTableCell("")),
                                  DataCell(customTableCell("")),
                                  DataCell(customTableCell(
                                      "${_controller.totalPrice()}")),
                                  DataCell(customTableCell(
                                      "${_controller.totalPriceAndRemain()}")),
                                  DataCell(customTableCell(
                                      "${_controller.totalCost()}")),        
                                  DataCell(customTableCell(
                                      "${_controller.totalCostAndRemain()}")),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Widget customTableCell(String text) {
  return ResponsiveConstraints(
    constraintsWhen: const [
      Condition.smallerThan(
          name: DESKTOP,
          value: BoxConstraints(
            maxWidth: 60,
          ))
    ],
    child: Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8,left: 5,right:5,),
      child:  Text(
          text,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ResponsiveValue(Get.context!, 
                              defaultValue: 16.0, 
                              valueWhen: [
                                Condition.smallerThan(
                                  name: DESKTOP,
                                  value: 12.0,
                                )
                              ],
                              ).value,
          ),
      ),
    ),
  );
}
