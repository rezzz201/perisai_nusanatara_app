import 'dart:convert';
import 'package:http/http.dart' as http;

class ListAbsenService {
  static Future<List<ListAbsenModel>> get(String param) async {
    try {
      final response = await http.get(Uri.parse(
          "https://hris.tpm-facility.com/attendance/listabsenidsite/" + param));
      if (200 == response.statusCode) {
        final List<ListAbsenModel> data = listAbsenModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ListAbsenModel> listAbsenModelFromJson(String str) =>
    List<ListAbsenModel>.from(
        json.decode(str).map((x) => ListAbsenModel.fromJson(x)));

String listAbsenModelToJson(List<ListAbsenModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListAbsenModel {
  ListAbsenModel({
    required this.attid,
    required this.currentdatetime,
    required this.attStatus,
    required this.keterangan,
    required this.nik,
    required this.hours,
    required this.name,
  });

  String attid;
  DateTime currentdatetime;
  String attStatus;
  String keterangan;
  String nik;
  String hours;
  String name;

  factory ListAbsenModel.fromJson(Map<String, dynamic> json) => ListAbsenModel(
        attid: json["attid"],
        currentdatetime: DateTime.parse(json["currentdatetime"]),
        attStatus: json["att_status"],
        keterangan: json["keterangan"],
        nik: json["nik"],
        hours: json["hours"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "attid": attid,
        "currentdatetime": currentdatetime.toIso8601String(),
        "att_status": attStatus,
        "keterangan": keterangan,
        "nik": nik,
        "hours": hours,
        "name": name,
      };
}
