import 'dart:convert';
import 'package:http/http.dart' as http;

class MemberService {
  static Future<List<ListMemberModel>> get(String param) async {
    try {
      final response = await http.get(Uri.parse(
          "https://hris.tpm-facility.com/attendance/listmember/" + param));
      if (200 == response.statusCode) {
        final List<ListMemberModel> data =
            listMemberModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ListMemberModel> listMemberModelFromJson(String str) =>
    List<ListMemberModel>.from(
        json.decode(str).map((x) => ListMemberModel.fromJson(x)));

String listMemberModelToJson(List<ListMemberModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListMemberModel {
  ListMemberModel({
    required this.nik,
    required this.name,
  });

  String nik;
  String name;

  factory ListMemberModel.fromJson(Map<String, dynamic> json) =>
      ListMemberModel(
        nik: json["nik"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "name": name,
      };
}
