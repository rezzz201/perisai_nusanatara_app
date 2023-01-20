import 'dart:convert';
import 'package:http/http.dart' as http;

class ListAbsensiStatusService {
  static Future<List<ListAbsensiStatus>>? get() async {
    try {
      final response = await http.get(Uri.parse(
          "https://hris.tpm-facility.com/attendance/listabsenstatus"));
      if (200 == response.statusCode) {
        final List<ListAbsensiStatus> data =
            listAbsensiStatusFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ListAbsensiStatus> listAbsensiStatusFromJson(String str) =>
    List<ListAbsensiStatus>.from(
        json.decode(str).map((x) => ListAbsensiStatus.fromJson(x)));

String listAbsensiStatusToJson(List<ListAbsensiStatus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListAbsensiStatus {
  ListAbsensiStatus({
    required this.id,
    required this.code,
    required this.keterangan,
  });

  String id;
  String code;
  String keterangan;

  factory ListAbsensiStatus.fromJson(Map<String, dynamic> json) =>
      ListAbsensiStatus(
        id: json["id"],
        code: json["code"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "keterangan": keterangan,
      };
}
