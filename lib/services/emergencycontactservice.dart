import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ContactServices {
  static Future<List<ContactModel>> getData() async {
    final response = await http.get(Uri.parse(
        'https://637db38316c1b892ebd275c5.mockapi.io/databook/kontak_darurat'));

    return compute(parseData, response.body);
  }

  static List<ContactModel> parseData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ContactModel>((json) => ContactModel.fromJson(json))
        .toList();
  }
}

class ContactModel {
  ContactModel({
    required this.nama,
    required this.notelepon,
    required this.service,
    required this.alamat,
  });

  String nama;
  String notelepon;
  String service;
  String alamat;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        nama: json["nama"],
        notelepon: json["no_telepon"],
        service: json["service"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "notelepon": notelepon,
        "service": service,
        "alamat": alamat,
      };
}
