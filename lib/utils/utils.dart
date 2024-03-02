import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hammies_user/controller/upload_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import '../widgets/pos/button/button.dart';
import '../widgets/show_loading/show_loading.dart';
import 'theme.dart';
import 'dart:html' as html;

Future<bool> colorPickerDialog(BuildContext context) async {
  final UploadController uploadController = Get.find();
  return ColorPicker(
    // Use the dialogPickerColor as start color.
    color: Colors.blue,
    onColorChanged: (v) {},
    // Update the dialogPickerColor using the callback.
    onColorChangeEnd: (Color color) {
      uploadController.colorController.add(color.value.toString());
    },
    width: 40,
    height: 40,
    borderRadius: 4,
    spacing: 5,
    runSpacing: 5,
    wheelDiameter: 155,
    heading: Text(
      'Select color',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    subheading: Text(
      'Select color shade',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    wheelSubheading: Text(
      'Selected color and its shades',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    showMaterialName: true,
    showColorName: true,
    showColorCode: true,
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      longPressMenu: true,
    ),
    materialNameTextStyle: Theme.of(context).textTheme.caption,
    colorNameTextStyle: Theme.of(context).textTheme.caption,
    colorCodeTextStyle: Theme.of(context).textTheme.caption,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: false,
      ColorPickerType.primary: true,
      ColorPickerType.accent: true,
      ColorPickerType.bw: false,
      ColorPickerType.custom: true,
      ColorPickerType.wheel: true,
    },
  ).showPickerDialog(
    context,
    constraints:
        const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
  );
}

extension VerticalExtension on int {
  Widget v() => SizedBox(
        height: this + 0.0,
      );
}

extension HorizontalExtension on int {
  Widget h() => SizedBox(
        width: this + 0.0,
      );
}

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

Future<void> saveImageIntoDirectory(Uint8List bytes) async {
  showSaving();
  final tempDire = await getTemporaryDirectory();
  await File("${tempDire.path}/${Uuid().v1()}.jpg")
      .writeAsBytes(bytes)
      .then((value) async {
    await ImageGallerySaver.saveFile(value.path).then((value) {
      hideSaving();
      Get.showSnackbar(GetSnackBar(
        message: "Saved",
      ));
      Future.delayed(
          const Duration(milliseconds: 1000), () => Get.closeCurrentSnackbar());
    });
  });
}

/* Future<Uint8List> getImageUnitBytes(pw.Document doc) async{
  //showSaving();
  final tempDire = await getTemporaryDirectory();
  final pdfByte = await doc.save();
  final tempFile = File("${tempDire.path}/${Uuid().v1()}.pdf");
  final file = await tempFile.writeAsBytes(pdfByte);
  final pdfFilePath = file.path;
  final document = await PdfDocument.openFile(pdfFilePath);
  final page = await document.getPage(1);
  final pageImage = await page.render(width: page.width*4, height: page.height*4,
    format: PdfPageImageFormat.jpeg,
    quality: 100,
    // backgroundColor:
  );
  return pageImage!.bytes;
} */

/* Future<Uint8List> getImageUnitBytes(pw.Document doc) async {
  final pdfBytes = await doc.save();
  final pdfDocument = PdfDocument.openData(pdfBytes);
  final pageCount = 1;
  final renderer = PdfPageImageRenderer(pdfDocument);

  // Render the first page as an image
  final pageImage = await renderer.renderPage(
    page: 1,
    x: 0,
    y: 0,
    width: pdfDocument.pageWidth,
    height: pdfDocument.pageHeight,
    format: PdfImageFormat.png,
    backgroundColor: '#ffffff', // Specify a background color if needed
  );

  // Convert the image to byte data
  final imageBytes = await pageImage.toByteData(format: PdfImageFormat.png);

  return imageBytes?.buffer.asUint8List();
} */

Future<ui.Image?> bytesToImage(Uint8List imgBytes) async {
  ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
  ui.FrameInfo frame = await codec.getNextFrame();
  return frame.image;
}

Future<void> openHtml(pw.Document document) async {
  Uint8List pdfInBytes = await document.save();
  final blob = html.Blob([pdfInBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  html.Url.revokeObjectUrl(url);
}

Future<void> downHtml(pw.Document document) async {
  Uint8List pdfInBytes = await document.save();
  final blob = html.Blob([pdfInBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  var anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'pdf.pdf';
  html.document.body?.children.add(anchor);
  anchor.click();
}
