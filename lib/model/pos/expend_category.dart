import 'package:cloud_firestore/cloud_firestore.dart';

class ExpendCategory {
  final String? id;
  final String category;
  ExpendCategory({required this.category, this.id});

  factory ExpendCategory.fromJson(
          Map<String, dynamic> json, QueryDocumentSnapshot<Map<String, dynamic>> snapShot) =>
      ExpendCategory(
        id: snapShot.id,
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
      };
}
