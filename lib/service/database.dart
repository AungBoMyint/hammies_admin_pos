import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/constant.dart';
import '../data/constant.dart';
import '../model/order_item.dart';
import '../model/pos/coupon.dart';
import '../model/pos/expend.dart';
import '../model/product_item.dart';

class Database {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watch(String collectionPath) =>
      _firebaseFirestore.collection(collectionPath).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRealOrder(
          String collectionPath) =>
      _firebaseFirestore
          .collection(collectionPath)
          .orderBy("dateTime", descending: true)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrder(
          String collectionPath) =>
      _firebaseFirestore
          .collection(collectionPath)
          .orderBy('dateTime', descending: true)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCoupon(
          String collectionPath) =>
      _firebaseFirestore
          .collection(collectionPath)
          .orderBy('expireDate', descending: true)
          .snapshots();

  Future<DocumentSnapshot<Map<String, dynamic>>> read(
    String collectionPath, {
    String? path,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).get();

  Future<void> write(
    String collectionPath, {
    String? path,
    required Map<String, dynamic> data,
  }) async {
    await _firebaseFirestore.collection(collectionPath).doc(path).set(data);
  }

  //Write PurchaseData
  Future<void> writePurchaseData(OrderItem model) async {
    try {
      await _firebaseFirestore
          .collection(posPurchaseCollection)
          .doc()
          .set(model.toJson())
          .then((value) async {
        //UPDATEREMAINQUANTITY
        for (var item in model.itemIdList) {
          await updateRemainQuantity(item);
          await updateTotalForDaily(item);
          await updateTotalForMonthly(item);
        }
      });
    } catch (e) {
      debugPrint("****************PurchseSubmitError $e*************");
    }
  }

  //Write PurchaseData
  Future<void> writeExpend(Expend expend) async {
    try {
      await _firebaseFirestore
          .collection(expendCollection)
          .doc(expend.dateTime)
          .set(expend.toJson())
          .then((value) async {
        //UPDATEREMAINQUANTITY
        await updateExpendForDaily(expend.cost);
        await updateExpendForMonthly(expend.cost);
      });
    } catch (e) {
      debugPrint("****************PurchseSubmitError $e*************");
    }
  }

  //Write PurchaseData
  Future<void> deleteExpend(Expend expend) async {
    try {
      await _firebaseFirestore
          .collection(expendCollection)
          .doc(expend.dateTime)
          .delete()
          .then((value) async {
        //UPDATEREMAINQUANTITY
        await subtractExpendForDaily(expend);
        await subtractExpendForMonthly(expend);
      });
    } catch (e) {
      debugPrint("****************PurchseSubmitError $e*************");
    }
  }

  Future<void> update(
    String collectionPath, {
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await _firebaseFirestore.collection(collectionPath).doc(path).update(data);
  }

  Future<void> delete(
    String collectionPath, {
    required String path,
  }) =>
      _firebaseFirestore.collection(collectionPath).doc(path).delete();

  /**BELOW FUNCTIONS ARE FOR POS */

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getDaysInCurrentMonthList() async {
    return await _firebaseFirestore
        .collection("${DateTime.now().year}Collection")
        .doc("${DateTime.now().year},${DateTime.now().month}")
        .get();
  }

  //Get Monthly Sales Data
  Future<QuerySnapshot<Map<String, dynamic>>> getMonthlySalesData({
    String? yearCollection,
  }) async {
    yearCollection ??= thisYearColleciton;

    return await _firebaseFirestore
        .collection(yearCollection)
        .orderBy("dateTimeMonth")
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenCoupon() {
    return _firebaseFirestore
        .collection(couponCollection)
        .orderBy("startDate", descending: true)
        .snapshots();
  }

  //Delete Coupon
  Future<void> deleteCoupon(String documentID) async {
    await _firebaseFirestore
        .collection(couponCollection)
        .doc(documentID)
        .delete();
  }

  //Add Coupon
  Future<void> uploadCoupon(Coupon coupon) async {
    await _firebaseFirestore
        .collection(couponCollection)
        .doc(coupon.documentID)
        .set(coupon.toJson());
  }

  /**BELOW ARE FUNCTIONS FOR POS USER*/
  //Subtract Remain Product
  Future<void> updateRemainQuantity(ProductItem product) async {
    //debugPrint("******${product.snapshot}*****");
    _firebaseFirestore.runTransaction((transaction) async {
      //secure snapshot
      final secureSnapshot = await transaction.get(
          _firebaseFirestore.collection(productCollection).doc(product.id));

      final int remainQuan = secureSnapshot.get("remainQuantity") as int;

      transaction.update(secureSnapshot.reference, {
        "remainQuantity": remainQuan - product.count!,
      });
    });
  }

  //Update TotalOrder and TotalPrice in today Map
  Future<void> updateTotalForDaily(ProductItem product) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection("${DateTime.now().year}Collection")
          .doc("${DateTime.now().year},${DateTime.now().month}"));

      try {
        final map = secureSnapshot.get("dateTime") as Map<String, dynamic>;
        final todayMap = map[dailyMapKey] as Map<String, dynamic>;
        final int totalOrder = todayMap["totalOrder"];
        final int totalPrice = todayMap["totalRevenue"];
        final int totalOriginalPrice = todayMap["originalTotalRevenue"];
        transaction.set(
            secureSnapshot.reference,
            {
              "dateTime": {
                dailyMapKey: {
                  "totalOrder": totalOrder + 1,
                  "totalRevenue": totalPrice + product.price * product.count!,
                  "originalTotalRevenue": totalOriginalPrice +
                      product.originalPrice * product.count!,
                },
              },
            },
            SetOptions(merge: true));
      } catch (e) {
        debugPrint("*********Error get totalOrder and Price $e**");
        transaction.set(
            secureSnapshot.reference,
            {
              "dateTime": {
                dailyMapKey: {
                  "totalOrder": 1,
                  "totalRevenue": product.price * product.count!,
                  "originalTotalRevenue":
                      product.originalPrice * product.count!,
                }
              },
            },
            SetOptions(merge: true));
      }
    });
  }

  //Update TotalOrder and TotalPrice in today Map
  Future<void> updateTotalForMonthly(ProductItem product) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection("${DateTime.now().year}Collection")
          .doc("${DateTime.now().year},${DateTime.now().month}"));
      debugPrint("*******Monthly:$secureSnapshot****");

      try {
        final int totalOrder = secureSnapshot.get("totalOrder");
        final int totalPrice = secureSnapshot.get("totalRevenue");
        final int totalOriginalPrice =
            secureSnapshot.get("originalTotalRevenue");
        transaction.set(
            secureSnapshot.reference,
            {
              "totalOrder": totalOrder + 1,
              "totalRevenue": totalPrice + product.price * product.count!,
              "originalTotalRevenue":
                  totalOriginalPrice + product.originalPrice * product.count!,
              "dateTimeMonth": DateTime.now(),
            },
            SetOptions(merge: true));
      } catch (e) {
        debugPrint("*********Error get totalOrder and Price $e**");
        transaction.set(
            secureSnapshot.reference,
            {
              "totalOrder": 1,
              "totalRevenue": product.price * product.count!,
              "originalTotalRevenue": product.originalPrice * product.count!,
              "dateTimeMonth": DateTime.now(),
            },
            SetOptions(merge: true));
      }
    });
  }

  //FOR EXPEND ************************ //
  //Update Expend in today Map
  Future<void> updateExpendForDaily(int cost) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection("${DateTime.now().year}Collection")
          .doc("${DateTime.now().year},${DateTime.now().month}"));

      try {
        final map = secureSnapshot.get("dateTime") as Map<String, dynamic>;
        final todayMap = map[dailyMapKey] as Map<String, dynamic>;
        final int totalExpend = todayMap["expend"];
        transaction.set(
            secureSnapshot.reference,
            {
              "dateTime": {
                dailyMapKey: {
                  "expend": totalExpend + cost,
                },
              },
            },
            SetOptions(merge: true));
      } catch (e) {
        debugPrint("*********Error get totalOrder and Price $e**");
        transaction.set(
            secureSnapshot.reference,
            {
              "dateTime": {
                dailyMapKey: {
                  "expend": cost,
                }
              },
            },
            SetOptions(merge: true));
      }
    });
  }

  //Update Expend in today Map
  Future<void> updateExpendForMonthly(int cost) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection("${DateTime.now().year}Collection")
          .doc("${DateTime.now().year},${DateTime.now().month}"));
      debugPrint("*******Monthly:$secureSnapshot****");

      try {
        final int totalExpend = secureSnapshot.get("expend");
        transaction.set(
            secureSnapshot.reference,
            {
              "expend": totalExpend + cost,
            },
            SetOptions(merge: true));
      } catch (e) {
        debugPrint("*********Error get totalOrder and Price $e**");
        transaction.set(
            secureSnapshot.reference,
            {
              "expend": cost,
            },
            SetOptions(merge: true));
      }
    });
  }

  //Subtract Expend in today Map
  Future<void> subtractExpendForDaily(Expend expend) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //first change date string to real date time to get expend's day
      DateTime expendDateTime = DateTime.parse(expend.dateTime);
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection("${expendDateTime.year}Collection")
          .doc("${expendDateTime.year},${expendDateTime.month}"));

      try {
        final map = secureSnapshot.get("dateTime") as Map<String, dynamic>;
        final todayMap = map[dailyMapKey] as Map<String, dynamic>;
        final int totalExpend = todayMap["expend"];
        transaction.set(
            secureSnapshot.reference,
            {
              "dateTime": {
                dailyMapKey: {
                  "expend": totalExpend - expend.cost,
                },
              },
            },
            SetOptions(merge: true));
      } catch (e) {
        debugPrint("*********Error delete expend: $e**");
        Get.snackbar(
          "Warning",
          "Something wrong.please contact to developer",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }

  //Subtract Expend in today Map
  Future<void> subtractExpendForMonthly(Expend expend) async {
    _firebaseFirestore.runTransaction((transaction) async {
      //first we change string date to real date time to get day
      DateTime expendDateTime = DateTime.parse(expend.dateTime);
      //secure snapshot
      final secureSnapshot = await transaction.get(_firebaseFirestore
          .collection("${expendDateTime.year}Collection")
          .doc("${expendDateTime.year},${expendDateTime.month}"));
      debugPrint("*******Monthly:$secureSnapshot****");

      try {
        final int totalExpend = secureSnapshot.get("expend");
        transaction.set(
            secureSnapshot.reference,
            {
              "expend": totalExpend - expend.cost,
            },
            SetOptions(merge: true));
      } catch (e) {
        debugPrint("*********Error subtract monthly expend $e**");
        Get.snackbar(
          "Warning",
          "Something wrong.please contact to developer",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }
}
