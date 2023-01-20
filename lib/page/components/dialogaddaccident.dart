import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:perisai_nusantara_app/page/home.dart';

class DialogAddActivity extends StatefulWidget {
  @override
  DialogAddActivityState createState() => DialogAddActivityState();
}

class DialogAddActivityState extends State<DialogAddActivity> {
  String nik = GetStorage().read('nik');
  late String activity;
  Future _postMessage() async {
    Map<String, dynamic> content = <String, dynamic>{};
    content['nik'] = nik;
    content['activity'] = activity;
    print(content);
    return await http.post(
      Uri.https('hris.tpm-facility.com', 'attendance/addactivities'),
      body: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Tambah Aktifitas",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    onChanged: (value) {
                      activity = value;
                    },
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration.collapsed(
                      hintText: "",
                    )),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    _postMessage();
                    Get.off(Home());
                    Get.snackbar("Berhasil!", "Aktifitas ditambahkan");
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
