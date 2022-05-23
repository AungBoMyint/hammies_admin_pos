import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final int originalPrice;
  final int quantity;
  final DateTime dateTime;
  final int remainQuantity;
  final int? count;
  final bool? select;
  final bool outOfOrder;
  final QueryDocumentSnapshot? snapshot;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.remainQuantity,
    this.select = false,
    this.count = 0,
    required this.dateTime,
    required this.outOfOrder,
    this.snapshot,
  });

  factory Product.fromJson(
          Map<String, dynamic> json, QueryDocumentSnapshot snapShot) =>
      Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        originalPrice: json["originalPrice"],
        quantity: json["quantity"],
        dateTime: (json["dateTime"] as Timestamp).toDate(),
        remainQuantity: json["remainQuantity"],
        outOfOrder: json["outOfOrder"],
        snapshot: snapShot,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "originalPrice": originalPrice,
        "quantity": quantity,
        "remainQuantity": remainQuantity,
        "dateTime": dateTime,
        "outOfOrder": outOfOrder,
      };

  Product copyWith({
    String? id,
    String? name,
    int? price,
    int? originalPrice,
    int? quantity,
    DateTime? dateTime,
    int? remainQuantity,
    int? count,
    bool? outOfOrder,
    QueryDocumentSnapshot? snapshot,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        originalPrice: originalPrice ?? this.originalPrice,
        quantity: quantity ?? this.quantity,
        dateTime: dateTime ?? this.dateTime,
        remainQuantity: remainQuantity ?? this.remainQuantity,
        count: count ?? this.count,
        outOfOrder: outOfOrder ?? this.outOfOrder,
        snapshot: snapshot ?? this.snapshot,
      );
}
