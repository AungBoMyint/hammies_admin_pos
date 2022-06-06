import 'dart:typed_data';

import 'package:flutter/material.dart' hide TableRow;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart' hide PdfDocument;
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../../../controller/home_controller.dart';
import '../../../../data/constant.dart';
import '../../../../model/order_item.dart';
import '../../../../utils/utils.dart';

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
  Uint8List? imageUnitBytes;

  @override
  void initState() {
    makePdfPage();
    super.initState();
  }

  void makePdfPage() async{
    HomeController _controller = Get.find();
    final byte = await rootBundle.load('assets/logo.png');
    final image = pw.MemoryImage(byte.buffer.asUint8List());
    final pw.Document doc = pw.Document();
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
            pw.Image(image, width: 80, height: 80),
            // pw.Text("Hammies Mandalian",
            //     style: const pw.TextStyle(
            //       fontSize: 8,
            //     )),
            // pw.SizedBox(height: 5),
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
                for (var item in widget.orderItem.itemIdList) ...[
                  pw.TableRow(
                    verticalAlignment: pw.TableCellVerticalAlignment.middle,
                    children: [
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                          child: pw.Text(
                            item.name,
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
                            "${(item.price) * (item.count!)} Ks",
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
            ),
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
                    child: pw.Text("${widget.orderItem.total} Ks",
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
              // height: 50,
              child: pw.Row(children: [
                pw.Expanded(flex: 2, child: pw.Text("")),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Pay:  ${widget.orderItem.pay} Ks",
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                        pw.Text(
                          "Change:  ${widget.orderItem.change} Ks",
                          textAlign: pw.TextAlign.right,
                          style: const pw.TextStyle(
                            fontSize: 8,
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
                  fontSize: 8,
                )),
            pw.SizedBox(height: 5),
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
    getImageUnitBytes(doc).then((value){
      setState(() {
        imageUnitBytes = value;
      });
    });
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
      body: imageUnitBytes == null ?
      Center(
        child: const SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.memory(imageUnitBytes!,fit: BoxFit.cover,),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: homeIndicatorColor,
              ),
              onPressed: () => saveImageIntoDirectory(imageUnitBytes!), child: Text("Save Photo in Gallery"),),
          )
        ],
      ),
    );
  }
}