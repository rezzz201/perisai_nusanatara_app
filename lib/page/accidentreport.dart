import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/roundedbutton.dart';
import 'package:perisai_nusantara_app/page/components/roundedinputfield.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class AccidentReport extends StatefulWidget {
  const AccidentReport({Key? key}) : super(key: key);

  @override
  _AccidentReportState createState() => _AccidentReportState();
}

class _AccidentReportState extends State<AccidentReport> {
  File? _image;
  ImagePicker imagePicker = ImagePicker();
  String nik = GetStorage().read('nik');
  String idsite = GetStorage().read('idsite');
  late String _title, _relatedNames, _relatedRemarks, _chronology, _takenAction;
  String? _date, _time;

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

  Future postUpload() async {
    var stream = new http.ByteStream(_image!.openRead());
    stream.cast();
    var length = await _image!.length();
    var url =
        Uri.parse('https://hris.tpm-facility.com/attendance/uploadaccident');
    var request = new http.MultipartRequest("POST", url);
    var multipartFile =
        new http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['nikreporter'] = nik;
    request.fields['thetime'] = _time!;
    request.fields['thedate'] = _date!;
    request.fields['title'] = _title;
    request.fields['idsite'] = idsite;
    request.fields['relatedfigure'] = _relatedNames;
    request.fields['figuresremark'] = _relatedRemarks;
    request.fields['chronology'] = _chronology;
    request.fields['takenaction'] = _takenAction;

    var response = await request.send();
    if (response.statusCode == 200) {
      print("IMAGE UPLOADED");
    } else {
      print("IMAGE FAILED");
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Visitor'),
      ),
      body: Stack(
        children: [
          CustomBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'No Visitor',
                        onChanged: (ket) {
                          _title = ket;
                        },
                        icon: FontAwesomeIcons.idCard,
                      ),
                      RoundedInputField(
                          width: size.width * 0.9,
                          icon: FontAwesomeIcons.home,
                          hintText: 'Alamat/Rumah Tujuan',
                          onChanged: (names) {
                            _relatedNames = names;
                          }),
                      BigTextField(
                        onChanged: (kronologi) {
                          _chronology = kronologi;
                        },
                        hint: 'Keperluan',
                      ),
                      _image == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Upload Foto KTP?',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                      RoundedButton(
                          text: 'Checkin',
                          color: Colors.red.shade800,
                          press: () {
                            if (_image == null &&
                                _date == null &&
                                _time == null) {
                              print(_title);
                              print(_date);
                              print(_time);
                              print(_relatedNames);
                              print(_relatedRemarks);
                              print(_chronology);
                              print(_takenAction);
                              Get.snackbar('Gagal',
                                  'Tambahkan foto/tanggal/waktu terlebih dahulu!',
                                  backgroundColor: Colors.white);
                            } else {
                              postUpload();
                              Get.back();
                              Get.snackbar('Berhasil!', 'Laporan terkirim.',
                                  backgroundColor: Colors.white);
                            }
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
          // Positioned(
          //   bottom: 30,
          //   right: 30,
          //   child: FloatingActionButton(
          //     onPressed: () {},
          //     child: FaIcon(FontAwesomeIcons.folderPlus),
          //   ),
          // )
        ],
      ),
    );
  }
}

class BigTextField extends StatelessWidget {
  const BigTextField({Key? key, required this.hint, required this.onChanged})
      : super(key: key);
  final String hint;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
          onChanged: onChanged,
          autocorrect: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: new InputDecoration.collapsed(
            hintText: hint,
          )),
    );
  }
}
