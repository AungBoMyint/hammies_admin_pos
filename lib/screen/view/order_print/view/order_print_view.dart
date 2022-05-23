import 'package:flutter/material.dart' hide TableRow;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/widgets.dart' hide TableRow;
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../controller/home_controller.dart';
import '../../../../model/order_item.dart';
import '../../../../model/product_item.dart';

class OrderPrintView extends StatefulWidget {
  final OrderItem orderItem;
  const OrderPrintView({
    Key? key,
    required this.orderItem,
  }) : super(key: key);

  @override
  State<OrderPrintView> createState() => _OrderPrintViewState();
}

class _OrderPrintViewState extends State<OrderPrintView> {
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
          250 + (widget.orderItem.itemIdList.length * 20),
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
            pw.Text("address: 33-44,HninSi Street",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.Text("phone: 09987898765",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.Text("email: hammies@gmail.com",
                style: const pw.TextStyle(
                  fontSize: 8,
                )),
            pw.SizedBox(height: 10),
            pw.Divider(
              borderStyle: pw.BorderStyle.solid,
            ),
            pw.Table(
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                pw.TableRow(
                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                    children: [
                      pw.Text("Qty",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: robotoBold,
                            fontSize: 10,
                          )),
                      pw.Text("Item",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: robotoBold,
                            fontSize: 10,
                          )),
                      pw.Text("Price",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: robotoBold,
                            fontSize: 10,
                          )),
                      pw.Text("Total",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: robotoBold,
                            fontSize: 10,
                          )),
                    ]),
                for (var item in widget.orderItem.itemIdList) ...[
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
                            fontSize: 10,
                          ),
                        ),
                      ),
                      pw.Expanded(
                          child: pw.Text(
                        item.name,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: robotoLight,
                          fontSize: 10,
                        ),
                      )),
                      pw.Expanded(
                          child: pw.Text(
                        "${item.price}ks",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: robotoLight,
                          fontSize: 10,
                        ),
                      )),
                      pw.Expanded(
                          child: pw.Text(
                        "${(item.price) * (item.count!)}ks",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: robotoLight,
                          fontSize: 10,
                        ),
                      )),
                    ],
                  ),
                ],
              ],
            ),
            pw.Divider(
              borderStyle: pw.BorderStyle.solid,
            ),
            pw.Table(children: [
              pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.Expanded(
                    child: pw.Text("TOTAL",
                        overflow: pw.TextOverflow.clip,
                        maxLines: 1,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                        )),
                  ),
                  pw.Expanded(
                    child: pw.Text(""),
                  ),
                  pw.Expanded(
                    child: pw.Text(""),
                  ),
                  pw.Expanded(
                    child: pw.Text("${widget.orderItem.total}ks",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
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
                pw.Expanded(flex: 2, child: pw.Text("")),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Pay:  ${widget.orderItem.pay}ks",
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        pw.Text(
                          "Change:  ${widget.orderItem.change}ks",
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]),
                ),
              ]),
            ),
            //Thank
            pw.Text("Thank you!",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: oleBold,
                  fontSize: 12,
                )),
            pw.Text(
              DateFormat("EEEE, dd MMM y kk:mm").format(DateTime.now()),
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(
                fontSize: 12,
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
              250 + (widget.orderItem.itemIdList.length * 20),
            ),
            "80mm": PdfPageFormat(
              503.92,
              250 + (widget.orderItem.itemIdList.length * 20),
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
