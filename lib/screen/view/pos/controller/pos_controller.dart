import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../../model/product_item.dart';
import '../view/pos_view.dart';

class PosController extends GetxController {
  bool loading = true;
  String categoryNameFilter = "All";
  String? barcodeResult;
  Map<String, dynamic>? orderDetail;
  List<ProductItem> orderItems = [];
  QuerySnapshot? productList;
  QuerySnapshot? categoryList;
  String search = "";

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  loadData() async {
    //productList = await userCollection.collection("products").get();
    //categoryList = await userCollection.collection("categories").get();
    loading = false;
    update();
  }

  updateFilter(value) async {
    categoryNameFilter = value;
    update();
  }

  void startScan() async {
    categoryNameFilter = "scanning";
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    barcodeResult = barcodeScanRes;
    if (barcodeResult == "-1") {
      categoryNameFilter = "All";
    }
    debugPrint("*******barcode: $barcodeResult");
    update();
  }

  addItemQty(ProductItem addedItem) {
    var searchList = orderItems.where((p) => p.id == addedItem.id).toList();

    if (searchList.isEmpty) {
      var item = addedItem;
      orderItems.add(item.copyWith(count: 1));
    } else {
      var item = searchList.first;
      orderItems[orderItems.indexOf(item)] =
          item.copyWith(count: item.count! + 1);
    }

    update();
  }

  subtractItemQty(ProductItem addedItem) {
    var searchList = orderItems.where((p) => p.id == addedItem.id).toList();

    if (searchList.isEmpty) {
      var item = addedItem;
      //orderItems.add(item.copyWith(count: 0));
    } else {
      var item = searchList[0];
      var itemCount = item.count! - 1;
      orderItems[orderItems.indexOf(item)] = item.copyWith(
        count: itemCount < 0 ? 0 : itemCount,
      );

      if (itemCount <= 0) {
        try {
          orderItems.removeWhere((element) => element.id == item.id);
        } catch (e) {
          debugPrint("");
        }
      }
    }

    update();
  }

  double get total {
    double total = 0;
    orderItems.forEach((item) {
      total += item.price * item.count! * 1.0;
    });
    return total;
  }

  createNewOrder() {
    orderDetail = {
      "id": Uuid().v1(),
      "created_at": DateTime.now(),
    };
    update();
  }

  resetState() {
    orderDetail = null;
    orderItems.clear();
    categoryNameFilter = "All";
    update();
  }
}
