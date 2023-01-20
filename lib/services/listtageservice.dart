import 'dart:convert';
import 'package:http/http.dart' as http;

class ListTagService {
  static Future<List<ListTagsModel>>? get() async {
    try {
      final response = await http
          .get(Uri.parse("https://hris.tpm-facility.com/attendance/listtags"));
      if (200 == response.statusCode) {
        final List<ListTagsModel> data = listTagsModelFromJson(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

List<ListTagsModel> listTagsModelFromJson(String str) =>
    List<ListTagsModel>.from(
        json.decode(str).map((x) => ListTagsModel.fromJson(x)));

String listTagsModelToJson(List<ListTagsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListTagsModel {
  ListTagsModel(
      {required this.nfcid,
      this.tagid,
      required this.idsite,
      required this.label,
      required this.isActive,
      required this.site});

  String nfcid;
  String? tagid;
  String idsite;
  String label;
  String isActive;
  String site;

  factory ListTagsModel.fromJson(Map<String, dynamic> json) => ListTagsModel(
      nfcid: json["nfcid"],
      tagid: json["tagid"],
      idsite: json["idsite"],
      label: json["label"],
      isActive: json["is_active"],
      site: json["site"]);

  Map<String, dynamic> toJson() => {
        "nfcid": nfcid,
        "tagid": tagid,
        "idsite": idsite,
        "label": label,
        "is_active": isActive,
        "site": site
      };
}
