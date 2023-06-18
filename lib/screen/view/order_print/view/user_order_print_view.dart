import 'dart:typed_data';

import 'package:flutter/material.dart' hide TableRow;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hammies_user/data/constant.dart';
import 'package:hammies_user/model/real_purchase.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../../../controller/home_controller.dart';
import '../../../../utils/utils.dart';

class UserOrderPrintView extends StatefulWidget {
  final PurchaseModel purchaseModel;

  final int total;
  final int shipping;
  final String township;
  final bool isView;
  const UserOrderPrintView({
    Key? key,
    required this.purchaseModel,
    required this.total,
    required this.shipping,
    required this.township,
    required this.isView,
  }) : super(key: key);

  @override
  State<UserOrderPrintView> createState() => _UserOrderPrintViewState();
}

class _UserOrderPrintViewState extends State<UserOrderPrintView> {
  String? imageUnitBytes;

  @override
  void initState() {
    makePdfPage();
    super.initState();
  }

  void makePdfPage() async {
    final pw.Document doc = pw.Document();
    HomeController _controller = Get.find();
    var oleBold = pw.Font.ttf(_controller.oleoBold);
    var oleRegular = pw.Font.ttf(_controller.oleoRegular);
    var robotoBold = pw.Font.ttf(_controller.robotoBold);
    var robotoLight = pw.Font.ttf(_controller.robotoLight);
    var today = DateFormat("ddMMMy").format(DateTime.now());
    final byte = await rootBundle.load('assets/logo.png');
    final image = pw.MemoryImage(byte.buffer.asUint8List());
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          359.043,
          250 +
              (((widget.purchaseModel.items?.length ?? 0) +
                  (widget.purchaseModel.items?.length ?? 0) * 20)),
        ),
        build: (pw.Context context) {
          return pw.ListView(children: [
            pw.SizedBox(height: 5),
            pw.Image(image, width: 80, height: 80),
            // pw.Text("Hammies Mandalian",
            //     style: const pw.TextStyle(
            //       fontSize: 8,
            //     )),
            pw.SizedBox(height: 5),

            pw.Text("Address: Mandalay",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.SizedBox(height: 5),
            pw.Text("Phone: 099 7511 4498",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.SizedBox(height: 5),
            pw.Text("Email: hammiesmandalian@gmail.com",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.SizedBox(height: 8),
            pw.Divider(
              borderStyle: pw.BorderStyle.solid,
            ),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.SizedBox(width: 2),
                        pw.Text("Item",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: robotoBold,
                              fontSize: 8,
                            )),
                        pw.Text("Qty",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: robotoBold,
                              fontSize: 8,
                            )),
                        pw.Text("Price",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: robotoBold,
                              fontSize: 8,
                            )),
                        pw.Text("Total",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: robotoBold,
                              fontSize: 8,
                            )),
                      ]),
                  if (!(widget.purchaseModel.items == null)) ...[
                    for (var item in widget.purchaseModel.items!) ...[
                      pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                              child: pw.Text(
                            item.itemName,
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                            child: pw.Text(
                              "${item.count}",
                              overflow: pw.TextOverflow.clip,
                              maxLines: 1,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: robotoLight,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          pw.Expanded(
                              child: pw.Text(
                            "${item.price} Ks",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            "${(item.price) * (item.count)} Ks",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ],
                  if (!(widget.purchaseModel.rewardProductList == null)) ...[
                    for (var item
                        in widget.purchaseModel.rewardProductList!) ...[
                      pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              "",
                              overflow: pw.TextOverflow.clip,
                              maxLines: 1,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: robotoLight,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          pw.Expanded(
                              child: pw.Text(
                            item.name,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                            child: pw.Text(
                              "${item.count}",
                              overflow: pw.TextOverflow.clip,
                              maxLines: 1,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                font: robotoLight,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          pw.Expanded(
                              child: pw.Text(
                            "${item.requirePoint} Points",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            "${item.requirePoint} Points",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ],
                ]),
            pw.Divider(
              borderStyle: pw.BorderStyle.solid,
            ),
            pw.Table(children: [
              pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.Expanded(
                    child: pw.Text("Total",
                        overflow: pw.TextOverflow.clip,
                        maxLines: 1,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        )),
                  ),
                  pw.Expanded(
                    child: pw.Text(""),
                  ),
                  pw.Expanded(
                    child: pw.Text(""),
                  ),
                  pw.Expanded(
                    child: pw.Text("${widget.total} Ks",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        )),
                  ),
                ],
              ),
            ]),
            pw.Divider(
              borderStyle: pw.BorderStyle.solid,
            ),
            pw.SizedBox(
              //height: 50,
              child: pw.Row(children: [
                pw.Expanded(child: pw.Text("")),
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: 20),
                  child: pw.Text(
                    "Delivery Fees:  ${widget.shipping} Ks",
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ),
              ]),
            ),
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //Name
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 10),
                        // pw.Text("Name: "),
                        pw.Text(
                          widget.purchaseModel.name,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                        pw.Text(
                          widget.purchaseModel.phone,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ]),

                  pw.SizedBox(width: 10, height: 5),

                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(width: 10),
                        // pw.Text("Name: "),
                        pw.Text(
                          widget.purchaseModel.email,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(width: 50),
                        pw.Text(
                          widget.purchaseModel.address,
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ]),
                ]),
            pw.SizedBox(height: 10),
            //Thank
            pw.Text("Thank you!",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: oleBold,
                  fontSize: 8,
                )),
            pw.SizedBox(height: 10),
            pw.Text(
              DateFormat("EEEE, dd MMM y kk:mm").format(DateTime.now()),
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(
                fontSize: 8,
              ),
            ),
          ]);
        },
      ),
    );
    widget.isView ? openHtml(doc) : downHtml(doc);
    Get.back();
    /*  getImageUnitBytes(doc).then((value) {
      setState(() {
        imageUnitBytes = value;
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.indigo),
        title: const Text(
          "Print Order",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              wordSpacing: 2,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
      ),
      body: imageUnitBytes == null
          ? Center(
              child: const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
/*           Image.memory(imageUnitBytes!,fit: BoxFit.cover,),
 */
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: homeIndicatorColor,
                    ),
                    onPressed:
                        () {} /* => saveImageIntoDirectory(imageUnitBytes!) */,
                    child: Text("Save Photo in Gallery"),
                  ),
                )
              ],
            ),
    );
  }
}
