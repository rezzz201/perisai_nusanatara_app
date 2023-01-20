import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BukuPaketService {
  static Future<List<BukuPaketModel>> getData(String idPaket) async {
    final response =
        await http.post(Uri.parse('http://192.168.1.16:5000/daftar-paket'));

    debugPrint('apipaket1 $response.body');
    return compute(parseData, response.body);
  }

  static List<BukuPaketModel> parseData(String responseBody) {
    debugPrint('apipaket2 $responseBody');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<BukuPaketModel>((json) => BukuPaketModel.fromJson(json))
        .toList();
  }
}

class BukuPaketModel {
  BukuPaketModel(
      {required this.idPaket,
      required this.tanggal,
      required this.namaPenerima,
      required this.barang,
      required this.kurir,
      required this.namaPetugas,
      required this.foto});

  String idPaket;
  String tanggal;
  String namaPenerima;
  String barang;
  String kurir;
  String namaPetugas;
  String foto;

  factory BukuPaketModel.fromJson(Map<String, dynamic> json) => BukuPaketModel(
      idPaket: json["id_paket"].toString(),
      tanggal: json["tanggal"].toString(),
      namaPenerima: json["nama_penerima"],
      barang: json["barang"],
      kurir: json["kurir"],
      namaPetugas: json["nama_petugas"],
      foto: json["foto"]
      //dateTime: DateTime.parse(json["date_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id_paket": idPaket,
        "tanggal": tanggal,
        "namaPenerima": namaPenerima,
        "barang": barang,
        "kurir": kurir,
        "nama_petugas": namaPetugas,
        "foto": foto
        //"date_time": dateTime.toIso8601String(),
      };
}
