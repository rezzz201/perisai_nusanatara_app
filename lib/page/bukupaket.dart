import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perisai_nusantara_app/services/bukupaketservice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/roundedbutton.dart';
import 'package:perisai_nusantara_app/page/components/roundedinputfield.dart';

class BukuPaket extends StatefulWidget {
  const BukuPaket({Key? key}) : super(key: key);

  @override
  _BukuPaketState createState() => _BukuPaketState();
}

class _BukuPaketState extends State<BukuPaket> {
  String idPaket = '';
  late DateTime _tanggal;
  late String _namaPenerima;
  late String _barang;
  late String _kurir;
  late String _namaPetugas;
  File? _foto;
  ImagePicker imagePicker = ImagePicker();
  //String? _date, _time;

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
        _foto = File(imageFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future postUpload() async {
    var stream = http.ByteStream(_foto!.openRead());
    stream.cast();
    var length = await _foto!.length();
    // Uri.parse = Mengikuti IP Address dari bawaan device || ipv4 used
    var url = Uri.parse('http://192.168.1.16:5000/daftar-tamu:foto');
    var request = http.MultipartRequest("POST", url);
    var multipartFile =
        http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['id_paket'] = idPaket;
    request.fields['tanggal'] = _tanggal as String;
    request.fields['barang'] = _barang;
    request.fields['kurir'] = _kurir;
    request.fields['nama_petugas'] = _namaPetugas;
    request.fields['nama_penerima'] = _namaPenerima;

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
        title: const Text('Buku Paket'),
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Tanggal',
                        onChanged: (tanggal) {
                          _tanggal = tanggal as DateTime;
                        },
                        icon: FontAwesomeIcons.calendar,
                      ),
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Nama Penerima',
                        onChanged: (namaPenerima) {
                          _namaPenerima = namaPenerima;
                        },
                        icon: FontAwesomeIcons.person,
                      ),
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Barang',
                        onChanged: (barang) {
                          _barang = barang;
                        },
                        icon: FontAwesomeIcons.boxOpen,
                      ),
                      RoundedInputField(
                          width: size.width * 0.9,
                          icon: FontAwesomeIcons.motorcycle,
                          hintText: 'Kurir',
                          onChanged: (kurir) {
                            _kurir = kurir;
                          }),
                      RoundedInputField(
                        width: size.width * 0.9,
                        icon: FontAwesomeIcons.personCircleCheck,
                        onChanged: (namaPetugas) {
                          _namaPetugas = namaPetugas;
                        },
                        hintText: 'Nama Petugas',
                      ),
                      _foto == null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Upload Bukti Terima',
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
                                          icon: const FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.red,
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "|",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                          },
                                          icon: const FaIcon(
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
                                  _foto = null;
                                });
                              },
                              child: Image.file(
                                _foto!,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                errorBuilder: (context, error, stactTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    width: 100,
                                    height: 100,
                                    child: const Center(
                                      child: Text('Error load image',
                                          textAlign: TextAlign.center),
                                    ),
                                  );
                                },
                              ),
                            ),
                      RoundedButton(
                          text: 'Kirim',
                          color: Colors.red.shade800,
                          press: () {
                            if (_foto == _foto && _tanggal == _tanggal) {
                              print(_barang);
                              print(_tanggal);
                              print(_namaPenerima);
                              print(_namaPetugas);
                              print(_kurir);
                              Get.snackbar('Gagal',
                                  'Tambahkan foto/tanggal/waktu terlebih dahulu!',
                                  backgroundColor: Colors.white);
                            } else {
                              postUpload();
                              Get.back();
                              Get.snackbar('Berhasil!', 'Data Di Rekam.',
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          decoration: InputDecoration.collapsed(
            hintText: hint,
          )),
    );
  }
}
