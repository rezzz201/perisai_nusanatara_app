import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:perisai_nusantara_app/page/components/roundedinputdate.dart';
import 'package:perisai_nusantara_app/page/components/roundedinputfield.dart';
import 'package:perisai_nusantara_app/page/components/roundedbuttonlaporan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:perisai_nusantara_app/page/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DialogAddLaporan extends StatefulWidget {
  const DialogAddLaporan({Key? key}) : super(key: key);

  @override
  DialogAddLaporanState createState() => DialogAddLaporanState();
}

class DialogAddLaporanState extends State<DialogAddLaporan> {
  File? foto;
  ImagePicker imagePicker = ImagePicker();
  String nama = 'nama';
  String nip = 'nip';
  String laporan='laporan';
  DateTime tanggal = DateTime(2023);

  Future _postMessage() async {
    Map<String, dynamic> content = <String, dynamic>{};
    content['nip'] = nip;
    content['nama'] = nama ;
    content['laporan'] = laporan;
    content['tanggal'] = tanggal;
    print(content);
    return await http.post(
      Uri.http('http://192.168.1.16:5000', '/laporan'),
      body: content,
    );
  }
  Future postUpload() async {
    var stream = http.ByteStream(foto!.openRead());
    stream.cast();
    var length = await foto!.length();
    var url = Uri.parse('http://192.168.1.16:5000/laporan');
    var request = http.MultipartRequest("POST", url);
    var multipartFile =
        http.MultipartFile("image", stream, length, filename: 'x.jpg');

    request.files.add(multipartFile);
    request.fields['nama'] = nama;
    request.fields['laporan'] = laporan;

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
        foto = File(imageFile!.path);
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
    Size size = MediaQuery.of(context).size;
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
                "Tambah Laporan",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Nama Petugas',
                        onChanged: (namavalue) {
                          nama = namavalue;
                        },
                        icon: FontAwesomeIcons.person,
                      ),
                      RoundedInputField(
                        width: size.width * 0.9,
                        hintText: 'Rincian Laporan',
                        onChanged: (laporanvalue) {
                          laporan = laporanvalue;
                        },
                        icon: FontAwesomeIcons.noteSticky,
                      ),
                   
                      RoundedInputDate( 
                        onDateChanged: (String tanggalvalue) {  

                        }, 
                        width: size.width * 0.9, 
                        firstDate: DateTime(2015, 8), 
                        initialDate: DateTime.now(), 
                        lastDate: DateTime(2101), 
                        hintText: 'Tanggal', 
                        dateFormat: DateFormat('yyyy-MM-dd')
                        
                        ),
                        RoundedButtonLaporan(
                          textColor: Colors.white, 
                          color: Colors.red.shade800, 
                          press: () { 
                            postUpload();
                          Get.off(Home());
                          Get.snackbar("Berhasil!", "Laporan ditambahkan");
                           }, 
                          text: 'Kirim Laporan',
                          ),
              // const SizedBox(
              //   height: 15,
              // ),
              // foto == null
              //     ? Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             Text(
              //               'Tambahkan Foto',
              //               style: TextStyle(color: Colors.grey[800]),
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 IconButton(
              //                     onPressed: () {
              //                       getImage(ImageSource.camera);
              //                     },
              //                     icon: FaIcon(
              //                       FontAwesomeIcons.camera,
              //                       color: Colors.red,
              //                     )),
              //                 Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text(
              //                     "|",
              //                     style: TextStyle(color: Colors.red),
              //                   ),
              //                 ),
              //                 IconButton(
              //                     onPressed: () {
              //                       getImage(ImageSource.gallery);
              //                     },
              //                     icon: const FaIcon(
              //                       FontAwesomeIcons.image,
              //                       color: Colors.red,
              //                     )),
              //               ],
              //             ),
              //           ],
              //         ),
              //       )
              //     : GestureDetector(
              //         onDoubleTap: () {
              //           setState(() {
              //             foto = null;
              //           });
              //         },
              //         child: Image.file(
              //           foto!,
              //           height: MediaQuery.of(context).size.height * 0.3,
              //           errorBuilder: (context, error, stactTrace) {
              //             return Container(
              //               color: Colors.grey,
              //               width: 100,
              //               height: 100,
              //               child: const Center(
              //                 child: Text('Gagal memuat gambar',
              //                     textAlign: TextAlign.center),
              //               ),
              //             );
              //           },
              //         ),
              //       ),
              // foto == foto
              //     ? const SizedBox()
              //     : Align(
              //         alignment: Alignment.bottomRight,
              //         child: IconButton(
              //           icon: const Icon(
              //             Icons.send,
              //             color: Colors.blue,
              //           ),
              //           onPressed: () {
              //             postUpload();
              //             Get.off(Home());
              //             Get.snackbar("Berhasil!", "Laporan ditambahkan");
              //           },
              //         ),
              //       ),
              
            ],
          ),
        ),
      ],
    );
  }
}
