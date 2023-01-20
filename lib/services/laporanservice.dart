import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LaporanServices {
  static Future<List<LaporanModel>> getData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.16:5000/laporan'));

    return compute(parseData, response.body);
  }

  static List<LaporanModel> parseData(String responseBody) {
    debugPrint('laporanServiceErr $responseBody');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<LaporanModel>((json) => LaporanModel.fromJson(json))
        .toList();
  }
}

class LaporanModel {
  LaporanModel({
    required this.laporanid,
    required this.nama,
    required this.laporan,
    required this.tanggal,
    //required this.foto,
  });

  String laporanid;
  String nama;
  String laporan;
  DateTime tanggal;
  //String foto;

  factory LaporanModel.fromJson(Map<String, dynamic> json) => LaporanModel(
        laporanid: json["laporanid"].toString(),
        nama: json["nama"],
        laporan: json["laporan"],
        tanggal: DateTime.parse(json["tanggal"]),
       
      );

  Map<String, dynamic> toJson() => {
        "laporanid": laporanid,
        "nama": nama,
        "Laporan": laporan,
        "date_time": tanggal.toIso8601String(),
        //"foto": foto,
      };
}
