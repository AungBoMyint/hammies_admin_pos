import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hammies_user/model/real_purchase.dart';
import 'package:hammies_user/model/reward_product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constant.dart';
import '../data/constant.dart';
import '../model/order_item.dart';
import '../model/pos/expend.dart';
import '../model/pos/expend_category.dart';
import '../model/product_item.dart';
import '../model/pos/coupon.dart';
import '../routes/routes.dart';
import '../service/api.dart';
import '../service/auth.dart';
import '../service/database.dart';
import '../widgets/show_loading/show_loading.dart';

class HomeController extends GetxController {
  final Auth _auth = Auth();
  final Database _database = Database();
  final Api _api = Api();
  final ImagePicker _imagePicker = ImagePicker();
  StreamSubscription? authSubscription;
  final RxBool authorized = false.obs;
  final Rxn<User?> user = Rxn<User?>(null);

  final RxBool phoneState = false.obs;
  final codeSentOnWeb = false.obs; //codeSentOnWeb on Web

  late SharedPreferences
      sharedPref; //Share Preference to Store User's Order Data
  String? townshipName; //Township Name
  var checkOutStep = 0.obs; //Check Out Step
  var bankSlipImage = "".obs;
  Map<String, dynamic> townShipNameAndFee = {}; //Township Name and Fee

  RxList<ExpendCategory> expendCategoryList = <ExpendCategory>[].obs;
  RxList<Expend> expendList = <Expend>[].obs;
  RxList<ExpendCategory> productCategoryList = <ExpendCategory>[].obs;

  final RxList<ProductItem> items = <ProductItem>[].obs;
  final RxList<RewardProduct> rewardItems = <RewardProduct>[].obs;
  final RxList<ProductItem> brandItems = <ProductItem>[].obs; //Brand Item
  final RxList<ProductItem> exportAndBrandItems = <ProductItem>[].obs;
  final RxList<ProductItem> searchitems = <ProductItem>[].obs;

  final RxList<OrderItem> orderItemList = <OrderItem>[].obs; ////
  final RxList<PurchaseModel> realOrderList = <PurchaseModel>[].obs;
/////////////////

  final RxBool isLoading = false.obs;
  Rxn<ProductItem?> editItem = Rxn<ProductItem?>(null);
  final RxList<String> categoryList = <String>[].obs;

  void setEditItem(ProductItem? model) {
    editItem.value = model;
  }

  //final RxList<PurchaseModel>  = <PurchaseModel>[].obs;

  List<PurchaseModel> purchcasesCashOn() {
    return realOrderList
        .where((item) => item.bankSlipImage == null && !(item.items == null))
        .toList();
  }

  List<PurchaseModel> purchcasesPrePay() {
    return realOrderList
        .where((item) => !(item.bankSlipImage == null) && !(item.items == null))
        .toList();
  }

  List<PurchaseModel> getRewardOrderOnly() {
    return realOrderList
        .where((model) =>
            (model.items == null) && !(model.rewardProductList == null))
        .toList();
  }

  //Loading Font to not take time when user in App to this font
  late ByteData oleoBold;
  late ByteData oleoRegular;
  late ByteData robotoLight;
  late ByteData robotoBold;
  late var image;
  @override
  void onInit() async {
    super.onInit(); // SharedPreference to Stroe
    oleoBold = await rootBundle.load("fonts/OleoScriptSwashCaps-Bold.ttf");
    oleoRegular =
        await rootBundle.load("fonts/OleoScriptSwashCaps-Regular.ttf");
    robotoLight = await rootBundle.load("fonts/Roboto-Light.ttf");
    robotoBold = await rootBundle.load("fonts/Roboto-Bold.ttf");
    _database.watch(productCollection).listen((event) {
      items.value =
          event.docs.map((e) => ProductItem.fromJson(e.data())).toList();
      refreshTotalProductAndRemainProduct();
    });
    _database.watch(rewardProductCollection).listen((event) {
      rewardItems.value =
          event.docs.map((e) => RewardProduct.fromJson(e.data())).toList();
      refreshTotalProductAndRemainProduct();
    });
    _database.watch(itemCollection).listen((event) {
      categoryList.value =
          event.docs.map((e) => e.data()["category"] as String).toList();
    });
    /**TODO TO MOVE THIS FUNCTION ONLY IF USER IS ADMIN */
    _database.watchOrder(posPurchaseCollection).listen((event) {
      if (event.docs.isEmpty) {
        orderItemList.clear();
      } else {
        orderItemList.value =
            event.docs.map((e) => OrderItem.fromJson(e.data())).toList();
        debugPrint("*****Total purchase: ${orderItemList.length}");
      }
    });
    _database.watchRealOrder(realPurchaseCollection).listen((event) {
      if (event.docs.isEmpty) {
        realOrderList.clear();
      } else {
        realOrderList.value =
            event.docs.map((e) => PurchaseModel.fromJson(e.data())).toList();
        debugPrint("*****Total purchase: ${orderItemList.length}");
      }
    });

    //Watch Expend Category
    /**TODO TO MOVE THIS FUNCTION ONLY IF USER IS ADMIN */
    _database.watch(expendCategoryCollection).listen((event) {
      if (event.docs.isEmpty) {
        expendCategoryList.clear();
      } else {
        expendCategoryList.value = event.docs
            .map((e) => ExpendCategory.fromJson(e.data(), e))
            .toList();
        debugPrint("*****ExpendCategories: ${expendCategoryList.length}");
      }
    });

    //Watch Expends
    /**TODO TO MOVE THIS FUNCTION ONLY IF USER IS ADMIN */
    _database.watch(expendCollection).listen((event) {
      if (event.docs.isEmpty) {
        expendList.clear();
      } else {
        expendList.value =
            event.docs.map((e) => Expend.fromJson(e.data())).toList();
        debugPrint("*****Expends: ${expendList.length}");
      }
    });

    //Watch Product Category
    _database.watch(productCategoryCollection).listen((event) {
      if (event.docs.isEmpty) {
        productCategoryList.clear();
      } else {
        productCategoryList.value = event.docs
            .map((e) => ExpendCategory.fromJson(e.data(), e))
            .toList();
      }
      debugPrint("*****ProductCategories: ${productCategoryList.length}");
    });

    ///
    _auth.onAuthChange().listen((_) async {
      if (_ == null) {
        authorized.value = false;
      } else {
        user.value = _;
        //authorized.value = true;
        if (!(authSubscription == null)) {
          authSubscription?.cancel();
        }

        authSubscription = await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(_.uid)
            .snapshots()
            .listen((event) {
          if (!(event.data() == null) &&
              event.data()?.isNotEmpty == true &&
              event.data()!["status"] > 0) {
            //authorized
            authorized.value = true;
          }
        });
        //First need to check,whether this use already has
        //document in Firebase Firestore
        final doc = await FirebaseFirestore.instance
            .collection(userCollection)
            .doc(_.uid)
            .get();
        if (!doc.exists) {
          await _database.write(
            userCollection,
            data: {
              'uid': _.uid,
              'user_name': _.displayName,
              'email': _.email,
              'status': 0,
            },
            path: _.uid,
          );
        }
      }
    });
  }

  /***New Add Variable and Function for POS*/
  var pieTouchIndex = -1.obs;
  var totalProduct = 0.obs;
  var remainProduct = 0.obs;
  RxList<Coupon> couponList = <Coupon>[].obs;
  Future<DocumentSnapshot<Map<String, dynamic>>> getDaysSales() async {
    return _database.getDaysInCurrentMonthList();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMonthsSales() async {
    return _database.getMonthlySalesData();
  }

  void refreshTotalProductAndRemainProduct() {
    totalProduct.value = 0;
    remainProduct.value = 0;
    if (items.isNotEmpty) {
      items.forEach((element) {
        totalProduct.value += element.originalQuantity;
        remainProduct.value += element.remainQuantity;
      });
    }
  }

  //Add Product Category
  Future<void> addProductCategory({required ExpendCategory category}) async {
    await _database.write(productCategoryCollection, data: category.toJson());
  }

  //Delete Product Category
  Future<void> deleteProductCategory({required String pathID}) async {
    await _database.delete(productCategoryCollection, path: pathID);
  }

  //Add Expend Category
  Future<void> addExpendCategory({required ExpendCategory category}) async {
    await _database.write(expendCategoryCollection, data: category.toJson());
  }

  //Delete Expend Category
  Future<void> deleteExpendCategory({required String pathID}) async {
    await _database.delete(expendCategoryCollection, path: pathID);
  }

  Future<void> saveExpend({required Expend expend}) async {
    await _database.writeExpend(expend);
  }

  Future<void> deleteExpend({required Expend expend}) async {
    await _database.deleteExpend(expend);
  }

  String? checkCouponIsValid(String? value) {
    return (couponList.isNotEmpty &&
            couponList.last.code == value &&
            DateTime.now().isBefore(couponList.last.expireDate))
        ? null
        : "Coupon is not valid";
  }

  bool checkCouponNotExistOrExpired() {
    return couponList.isEmpty ||
        DateTime.now().isAfter(couponList.last.expireDate);
  }

  Future<void> deleteProduct(String pathID) async {
    showLoading();
    await _database.delete(itemCollection, path: pathID);
    hideLoading();
    Get.back();
  }

  Future<void> signInWithGoogle() async {
    showLoading();
    if (kIsWeb) {
      await signInWithGoogleForWeb();
    } else {
      await signInWithGoogleForNative();
    }
  }

  Future<void> signInAnonymous() async {
    showLoading();
    try {
      await FirebaseAuth.instance.signInAnonymously();
      hideLoading();
      Get.offNamed(homeScreen);
      debugPrint("***Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      hideLoading();
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint(
              "****Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          debugPrint("***Unkown error.");
      }
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offNamed(loginUrl);
  }

  Future<void> signInWithGoogleForNative() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      hideLoading();
      Get.offNamed(homeScreen);
    } catch (e) {
      debugPrint("********$e");
      hideLoading();
    }
  }

  Future<void> handleSignIn() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      // Handle sign-in success
    } catch (error) {
      // Handle sign-in error
    }
  }

  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  Future<void> signInWithGoogleForWeb() async {
    // Create a new provider
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      hideLoading();
      Get.offNamed(homeScreen);
    } catch (e) {
      debugPrint("********Error sign in web: $e");
      hideLoading();
    }
  }

  int totalPrice() {
    var result = 0;
    for (var item in items) {
      result += item.price;
    }
    return result;
  }

  int totalPriceAndRemain() {
    var result = 0;
    for (var item in items) {
      result += item.price * item.remainQuantity;
    }
    return result;
  }

  int totalCost() {
    var result = 0;
    for (var item in items) {
      result += item.originalPrice;
    }
    return result;
  }

  int totalCostAndRemain() {
    var result = 0;
    for (var item in items) {
      result += item.originalPrice * item.remainQuantity;
    }
    return result;
  }
}
