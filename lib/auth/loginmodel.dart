import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<UserAuth?> fetchData(String email, String password) async {
    final response = await http.post(
        Uri.parse('http://192.168.1.16:5000/login-anggota'),
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return UserAuth.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

class UserAuth {
  UserAuth({
    required this.nip,
    required this.name,
    required this.idSite,
    required this.site,
    required this.idPosition,
    required this.email,
    required this.password,
    required this.status,
  });

  String nip;
  String name;
  String idSite;
  String site;
  String idPosition;
  String email;
  String password;
  String status;

  factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
        nip: json['user']["nip"].toString(),
        name: json['user']["name"],
        idSite: json['user']["id_site"].toString(),
        site: json['user']["site"],
        idPosition: json['user']["id_position"].toString(),
        email: json['user']["email"],
        password: json['user']["password"],
        status: json['user']["status"],
      );

  Map<String, dynamic> toJson() => {
        "nip": nip,
        "name": name,
        "id_site": idSite,
        "site": site,
        "id_position": idPosition,
        "email": email,
        "password": password,
        "status": status,
      };
}
