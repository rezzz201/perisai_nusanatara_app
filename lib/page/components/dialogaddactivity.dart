import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:perisai_nusantara_app/page/home.dart';

class DialogAddActivity extends StatefulWidget {
  const DialogAddActivity({Key? key}) : super(key: key);

  @override
  DialogAddActivityState createState() => DialogAddActivityState();
}

class DialogAddActivityState extends State<DialogAddActivity> {
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String nik = 'nik';
  late String activity;

  // Future _postMessage() async {
  //   Map<String, dynamic> content = <String, dynamic>{};
  //   content['nik'] = nik;
  //   content['activity'] = activity;
  //   print(content);
  //   return await http.post(
  //     Uri.https('hris.tpm-facility.com', 'attendance/addactivities'),
  //     body: content,
  //   );
  // }
  Future postUpload() async {
    var stream = new http.ByteStream(_image!.openRead());
    stream.cast();
    var length = await _image!.length();
    var url =
        Uri.parse('https://hris.tpm-facility.com/attendance/addactivities');
    var request = new http.MultipartRequest("POST", url);
    var multipartFile =
        new http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['nik'] = nik;
    request.fields['activity'] = activity;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("IMAGE UPLOADED");
    } else {
      print("IMAGE FAILED");
    }
  }

  getPermission() async {
    var cameraPermission = await Permission.camera.status;
    if (!cameraPermission.isGranted) {
      await Permission.camera.request();
    }
  }

  Future getImage(ImageSource imageSource) async {
    var imageFile = await imagePicker.pickImage(source: imageSource);
    try {
      setState(() {
        _image = File(imageFile!.path);
      });
    } catch (e) {
      print(e);
    }
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
              SizedBox(
                height: 15,
              ),
              _image == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Tambahkan Foto',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    getImage(ImageSource.camera);
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.red,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "|",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.image,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Image.file(
                        _image!,
                        height: MediaQuery.of(context).size.height * 0.3,
                        errorBuilder: (context, error, stactTrace) {
                          return Container(
                            color: Colors.grey,
                            width: 100,
                            height: 100,
                            child: const Center(
                              child: const Text('Error load image',
                                  textAlign: TextAlign.center),
                            ),
                          );
                        },
                      ),
                    ),
              _image == null
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          postUpload();
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
