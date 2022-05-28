import 'package:flutter/material.dart' hide TableRow;
import 'package:get/get.dart';
import 'package:hammies_user/model/real_purchase.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/widgets.dart' hide TableRow;
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../../../controller/home_controller.dart';

class UserOrderPrintView extends StatefulWidget {
  final PurchaseModel purchaseModel;

  final int total;
  final int shipping;
  final String township;
  const UserOrderPrintView({
    Key? key,
    required this.purchaseModel,
    required this.total,
    required this.shipping,
    required this.township,
  }) : super(key: key);

  @override
  State<UserOrderPrintView> createState() => _UserOrderPrintViewState();
}

class _UserOrderPrintViewState extends State<UserOrderPrintView> {
  final pw.Document doc = pw.Document();

  @override
  void initState() {
    makePdfPage();
    super.initState();
  }

  void makePdfPage() {
    HomeController _controller = Get.find();
    var oleBold = pw.Font.ttf(_controller.oleoBold);
    var oleRegular = pw.Font.ttf(_controller.oleoRegular);
    var robotoBold = pw.Font.ttf(_controller.robotoBold);
    var robotoLight = pw.Font.ttf(_controller.robotoLight);
    var today = DateFormat("ddMMMy").format(DateTime.now());
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
            pw.Image(_controller.image, width: 50, height: 50),
            pw.SizedBox(height: 2),
            pw.Text("Hammies Mandalian",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.Text("Address: Mandalay",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.Text("Phone: 09975114498",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
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

                          pw.Expanded(
                              child: pw.Text(
                            item.itemName,
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
                            "${item.price} Ks",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            "${(item.price) * (item.count)}ks",
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
                            item.name,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            "${item.requirePoint} points",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              font: robotoLight,
                              fontSize: 8,
                            ),
                          )),
                          pw.Expanded(
                              child: pw.Text(
                            "0 Ks",
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
                        "Delivery Fees:  ${widget.shipping} ks",
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),),
              ]),
            ),
            //Thank
            pw.Text("Thank you!",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: oleBold,
                  fontSize: 8,
                )),
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
      body: SafeArea(
        child: PdfPreview(
          /* actions: [
            PdfPreviewAction(
                icon: const Icon(
                  Icons.print,
                  color: Colors.white,
                ),
                onPressed: (_, __, ___) async {
                  await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async => doc.save());
                }),
          ],*/
          pageFormats: {
            "57mm": PdfPageFormat(
              359.043,
              250 +
                  ((widget.purchaseModel.items?.length ?? 0) +
                      (widget.purchaseModel.items?.length ?? 0) * 20),
            ),
            "80mm": PdfPageFormat(
              503.92,
              250 +
                  ((widget.purchaseModel.items?.length ?? 0) +
                      (widget.purchaseModel.items?.length ?? 0) * 20),
            ),
          },
          build: (format) => doc.save(),
          onPrinted: (context) async {
            await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => doc.save());
          },
        ),
      ),
    );
  }
}
