import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DialogTambahTamu extends StatefulWidget {
  const DialogTambahTamu({Key? key}) : super(key: key);

  @override
  DialogTambahTamuState createState() => DialogTambahTamuState();
}

class DialogTambahTamuState extends State<DialogTambahTamu> {
  String idBukutamu = GetStorage().read('id_bukutamu');
  late String counts;
  Future _postMessage() async {
    Map<String, dynamic> content = <String, dynamic>{};
    content['id_bukutamu'] = idBukutamu;
    content['counts'] = counts;
    print(content);
    return await http.post(
      Uri.https('http://192.168.1.16:5000', '/daftar-tamu'),
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
          padding:
              const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Jumlah Tamu Hari Ini",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    onChanged: (value) {
                      counts = value;
                    },
                    textAlign: TextAlign.center,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.number,
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
                    Get.back();
                    Get.snackbar(
                        "Berhasil!", "Jumlah tamu berhasil ditetapkan");
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
