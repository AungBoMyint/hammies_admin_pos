import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  final String? id;
  final List items;
  final String name;
  final String email;
  final int phone;
  final String address;
  final String? bankSlipImage;
  final List deliveryTownshipInfo;
  final DateTime? dateTime;

  PurchaseModel({
    this.id,
    required this.items,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.deliveryTownshipInfo,
    required this.bankSlipImage,
    this.dateTime,
  });

  //Object Clone
  PurchaseModel copyWith({
    String? id,
    List? items,
    String? name,
    String? email,
    int? phone,
    String? address,
    String? bankSlipImage,
    List? deliveryTownshipInfo,
    DateTime? dateTime,
  }) =>
      PurchaseModel(
        items: items ?? this.items,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        deliveryTownshipInfo: deliveryTownshipInfo ?? this.deliveryTownshipInfo,
        bankSlipImage: bankSlipImage ?? this.bankSlipImage,
      );

  factory PurchaseModel.fromJson(Map<String, dynamic> json, String id) =>
      PurchaseModel(
        id: id,
        items: json['items'] as List,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as int,
        address: json['address'] as String,
        bankSlipImage: json['bankSlipImage'] as String?,
        deliveryTownshipInfo: json['deliveryTownshipInfo'] as List,
        dateTime: (json['dateTime'] as Timestamp).toDate(),
      );

  @override
  String toString() {
    return "$id,$items,$name,$email,$phone,$address,$bankSlipImage,$deliveryTownshipInfo,$dateTime";
  }

  Map<String, dynamic> toJson() => {
        'items': items,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'bankSlipImage': bankSlipImage,
        'deliveryTownshipInfo': deliveryTownshipInfo,
        'dateTime': dateTime ?? DateTime.now(),
      };
}
