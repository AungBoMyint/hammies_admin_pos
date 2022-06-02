import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../widgets/pos/button/button.dart';
import '../widgets/show_loading/show_loading.dart';
import 'theme.dart';


var currentDateTime =
    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

enum Filter {
  all,
  date,
}

List<DateTime> startDateToEndDateList() {
  var from = DateTime(DateTime.now().year, DateTime.now().month, 1);
  var to =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int difDay = (to.difference(from).inHours / 24).round();
  debugPrint("*********TotalDiffDay: $difDay");
  return List.generate(difDay + 1, (index) {
    debugPrint("*****Day: ${index + 1}");
    return DateTime(DateTime.now().year, DateTime.now().month, index + 1);
  });
}

//BlueWarnning
void showBlueWarnning() {
  Get.defaultDialog(
      barrierDismissible: false,
      title: "Warnning",
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Please turn on bluetooth.",
            ),
            ExButton(
              color: theme.primary,
              label: "OK",
              onPressed: () => Get.back(),
            ),
          ]));
}


//Save JPG into Gallery

Future<void> saveImageIntoDirectory(pw.Document doc) async{
    showSaving();
    final tempDire = await getTemporaryDirectory();
    final pdfByte = await doc.save();
    final tempFile = File("${tempDire.path}/${Uuid().v1()}.pdf");
    await tempFile.writeAsBytes(pdfByte)
    .then((value) async{
        final pdfFilePath = value.path;
        final document = await PdfDocument.openFile(pdfFilePath);
        final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height,
    format: PdfPageImageFormat.jpeg,
   // backgroundColor: 
    );
    debugPrint("******JPGBytes: ${pageImage!.bytes}");
    final jpgByte = pageImage.bytes;
     await File("${tempDire.path}/${Uuid().v1()}.jpg").writeAsBytes(jpgByte)
     .then((value) async{
       await ImageGallerySaver.saveFile(value.path)
       .then((value){
         hideSaving();
         Get.showSnackbar(GetSnackBar(
           message: "Saved",
         ));
         Future.delayed(const Duration(milliseconds: 1000),() => Get.closeCurrentSnackbar());
       });
     });
    });
  }
