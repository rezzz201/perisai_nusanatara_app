import 'dart:convert';
import 'package:http/http.dart' as http;

class ListCheckPointService {
  static Future<List<ListCheckPointModel>> get(String param) async {
    try {
      final response = await http.get(Uri.parse(
          "https://hris.tpm-facility.com/attendance/listcheckpointidsite/" +
              param));
      if (200 == response.statusCode) {
        final List<ListCheckPointModel> data =
            listCheckPointModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ListCheckPointModel> listCheckPointModelFromJson(String str) =>
    List<ListCheckPointModel>.from(
        json.decode(str).map((x) => ListCheckPointModel.fromJson(x)));

String listCheckPointModelToJson(List<ListCheckPointModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListCheckPointModel {
  ListCheckPointModel({
    required this.cheId,
    required this.currentdatetime,
    required this.isclear,
    this.desc,
    required this.location,
    required this.name,
  });

  String cheId;
  DateTime currentdatetime;
  String isclear;
  String? desc;
  String location;
  String name;

  factory ListCheckPointModel.fromJson(Map<String, dynamic> json) =>
      ListCheckPointModel(
        cheId: json["che_id"],
        currentdatetime: DateTime.parse(json["currentdatetime"]),
        isclear: json["isclear"],
        desc: json["desc"],
        location: json["location"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "che_id": cheId,
        "currentdatetime": currentdatetime.toIso8601String(),
        "isclear": isclear,
        "desc": desc,
        "location": location,
        "name": name,
      };
}
