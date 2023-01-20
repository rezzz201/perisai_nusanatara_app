import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BukuBukuTamuServices {
  static Future<List<BukuTamuModel>> postData(String idbukuBukuTamu) async {
    final response =
        await http.post(Uri.parse('http://192.168.1.16:5000/daftar-tamu'));

    debugPrint('apiBukuTamu $response.body');
    return compute(parseData, response.body);
  }

  static List<BukuTamuModel> parseData(String responseBody) {
    debugPrint('apiBukuTamu2 $responseBody');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<BukuTamuModel>((json) => BukuTamuModel.fromJson(json))
        .toList();
  }
}

class BukuTamuModel {
  BukuTamuModel(
      {required this.idbukuBukuTamu,
      required this.noVisitor,
      required this.nama,
      required this.tanggal,
      required this.telepon,
      required this.alamat,
      required this.keperluan,
      required this.foto});

  String idbukuBukuTamu;
  String noVisitor;
  String nama;
  String tanggal;
  String telepon;
  String alamat;
  String keperluan;
  String foto;

  factory BukuTamuModel.fromJson(Map<String, dynamic> json) => BukuTamuModel(
      idbukuBukuTamu: json["id_bukuBukuTamu"].toString(),
      noVisitor: json["no_visitor"].toString(),
      nama: json["nama"],
      tanggal: json["tanggal"].toString(),
      telepon: json["telepon"].toString(),
      alamat: json["alamat"],
      keperluan: json["keperluan"],
      foto: json["foto"]);

  Map<String, dynamic> toJson() => {
        "id_bukuBukuTamu": idbukuBukuTamu,
        "no_visitor": noVisitor,
        "nama": nama,
        "tanggal":tanggal,
        "telepon": telepon,
        "alamat": alamat,
        "keperluan": keperluan,
        "foto": foto
      };
}
