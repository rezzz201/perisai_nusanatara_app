import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ActivityServices {
  static Future<List<AcitivityModel>> getData(String idsite) async {
    final response = await http.get(Uri.parse(
        'https://hris.tpm-facility.com/attendance/listactivitiesidsite/' +
            idsite));

    return compute(parseData, response.body);
  }

  static List<AcitivityModel> parseData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<AcitivityModel>((json) => AcitivityModel.fromJson(json))
        .toList();
  }
}

class AcitivityModel {
  AcitivityModel({
    required this.activityid,
    required this.name,
    required this.activity,
    required this.dateTime,
    required this.images,
  });

  String activityid;
  String name;
  String activity;
  DateTime dateTime;
  String images;

  factory AcitivityModel.fromJson(Map<String, dynamic> json) => AcitivityModel(
        activityid: json["activityid"],
        name: json["name"],
        activity: json["activity"],
        dateTime: DateTime.parse(json["date_time"]),
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "activityid": activityid,
        "name": name,
        "activity": activity,
        "date_time": dateTime.toIso8601String(),
        "images": images,
      };
}
