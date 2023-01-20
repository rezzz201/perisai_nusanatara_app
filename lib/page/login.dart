import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/auth/loginmodel.dart';
import 'package:perisai_nusantara_app/page/components/roundedbutton.dart';
import 'package:perisai_nusantara_app/page/components/roundedpasswordfield.dart';
import 'package:perisai_nusantara_app/page/home.dart';
import 'package:perisai_nusantara_app/page/settag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/roundedinputfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

const _forgotPasswordUrl = '';

class _LoginState extends State<Login> {
  late UserAuth userAuth;
  late String email, password;
  bool invisiblePw = true;
  final getStorage = GetStorage();

  void saveData() async {
    getStorage.write("nip", userAuth.nip);
    getStorage.write("idsite", userAuth.idSite);
    getStorage.write("site", userAuth.site);
    getStorage.write("idposition", userAuth.idPosition);
    getStorage.write("email", userAuth.email);
    getStorage.write("name", userAuth.name);
    getStorage.write("status", userAuth.status);
  }

  void _launchURL() async => await canLaunch(_forgotPasswordUrl)
      ? await launch(_forgotPasswordUrl)
      : throw 'Could not launch $_forgotPasswordUrl';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "LOGIN-ANGGOTA",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                icon: Icons.person,
                hintText: "Email",
                onChanged: (evalue) {
                  email = evalue;
                },
              ),
              RoundedPasswordField(
                onEyeTap: () {
                  setState(() {
                    invisiblePw = !invisiblePw;
                  });
                },
                invisible: invisiblePw,
                onChanged: (pvalue) {
                  password = pvalue;
                },
              ),
              RoundedButton(
                color: Colors.red.shade700,
                text: "MASUK",
                press: () {
                  AuthService.fetchData(email.trim(), password).then((value) {
                    if (value != null) {
                      userAuth = value;
                      saveData();
                      Get.offAll(Home());
                    } else {
                      print("Tidak Terdaftar");
                      Get.snackbar('Gagal', 'Email dan Password tidak sesuai');
                    }
                  });
                },
              ),
              TextButton(
                  onPressed: () {
                    _launchURL();
                  },
                  onLongPress: () {
                    Get.to(() => SetTag());
                  },
                  child: Text(
                    "",
                    style: TextStyle(color: Colors.red.shade500),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
