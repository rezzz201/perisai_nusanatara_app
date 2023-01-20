import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/customdialog.dart';
import 'package:perisai_nusantara_app/page/components/customdialogwithcontainer.dart';
import 'package:perisai_nusantara_app/page/components/roundedbutton.dart';
import 'package:intl/intl.dart';
import 'package:perisai_nusantara_app/services/listcheckpoint.dart';

class CheckPointPage extends StatefulWidget {
  const CheckPointPage({Key? key}) : super(key: key);

  @override
  _CheckPointPageState createState() => _CheckPointPageState();
}

class _CheckPointPageState extends State<CheckPointPage> {
  GetStorage session = GetStorage();
  late String tagId;
  late int isKondusif;
  String desc = "";

  void readCheckPointNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        tagId = tag.data['nfca']['identifier'].join();
        NfcManager.instance.stopSession();
        Get.back();
        statusKondisi();
        // postCheckPoint();
      });
      showDialog(
          context: context,
          builder: (context) => CustomDialogBox(
                title: 'Scanning ...',
                descriptions: 'Tempelkan pada Tag NFC',
                textButton: TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    NfcManager.instance.stopSession();
                    Get.back();
                  },
                ),
              ));
      // NfcManager.instance.stopSession();
    } else {
      showDialog(
          context: context,
          builder: (context) => CustomDialogBox(
                title: 'Ooops! ...',
                descriptions: "Pastikan fitur NFC aktif pada perangkat anda",
                textButton: TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Get.back();
                    // Get.offAll(Home());
                  },
                ),
              ));
    }
  }

  Future<void> statusKondisi() {
    return showDialog(
        context: context,
        builder: (context) => CustomDialogContainer(
              title: "Status Kondisi",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedButton(
                    text: "Kondusif",
                    press: () {
                      setState(() {
                        isKondusif = 1;
                        desc = "";
                      });
                      postCheckPoint();
                    },
                    color: Colors.blue,
                  ),
                  RoundedButton(
                    text: "Tidak Kondusif",
                    press: () {
                      setState(() {
                        isKondusif = 0;
                      });
                      Get.back();
                      description();
                    },
                    color: Colors.red.shade400,
                  ),
                ],
              ),
            ));
  }

  Future<void> description() {
    return showDialog(
        context: context,
        builder: (context) => CustomDialogContainer(
              title: "Berikan keterangan",
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                    onChanged: (value) {
                      desc = value;
                    },
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration.collapsed(
                      hintText: "",
                    )),
              ),
              textButton: TextButton(
                onPressed: () {
                  postCheckPoint();
                },
                child: Text("Kirim"),
              ),
            ));
  }

  Future postCheckPoint() async {
    final response = await http.post(
        Uri.parse('https://hris.tpm-facility.com/attendance/checkpointbynfc'),
        body: {
          'nik': session.read('nik'),
          'tagid': tagId,
          'iskondusif': isKondusif.toString(),
          'desc': desc
        });
    if (response.statusCode == 200) {
      Get.back();
      Get.snackbar('Berhasil!', 'Check Point ditambahkan',
          backgroundColor: Colors.white);
    } else {
      Get.snackbar('Gagal', 'Silahkan hubungi developer',
          backgroundColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Check Point Patroli',
                        style: TextStyle(
                            fontSize: 25,
                            // color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "klik tombol 'tambah' untuk menambahkan patroli hari ini",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      RoundedButton(
                          text: 'Tambah',
                          color: Colors.red.shade800,
                          press: () {
                            readCheckPointNFC();
                          })
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      "Daftar Patroli Hari Ini:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white38),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(15),
                    child: FutureBuilder<List<ListCheckPointModel>>(
                      future: ListCheckPointService.get(session.read('idsite')),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('An error has occurred!'),
                          );
                        } else if (snapshot.hasData &&
                            snapshot.data!.length > 0) {
                          return CheckPointList(checkpoints: snapshot.data!);
                        } else {
                          return Center(
                            child: Text(
                              'Tambahkan checkpoint untuk hari ini.',
                              style: TextStyle(color: Colors.white38),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CheckPointList extends StatelessWidget {
  const CheckPointList({Key? key, required this.checkpoints}) : super(key: key);
  final List<ListCheckPointModel> checkpoints;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: checkpoints.length,
        itemBuilder: (context, index) {
          ListCheckPointModel data = checkpoints[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.circle,
                  color: (data.isclear == "1") ? Colors.blue : Colors.red,
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.location,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("oleh " +
                        data.name +
                        " pada " +
                        DateFormat('kk:mm').format(data.currentdatetime)),
                    data.desc == null
                        ? SizedBox()
                        : Text(
                            "ket: " + data.desc!,
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
