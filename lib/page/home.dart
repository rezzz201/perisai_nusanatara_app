import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/accidentreport.dart';
import 'package:perisai_nusantara_app/page/activity.dart';
import 'package:perisai_nusantara_app/page/bukupaket.dart';
import 'package:perisai_nusantara_app/page/bukutamu.dart';
import 'package:perisai_nusantara_app/page/checkpoint.dart';
import 'package:perisai_nusantara_app/page/components/customdialog.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:perisai_nusantara_app/page/components/dialogaddvisitor.dart';
import 'package:perisai_nusantara_app/page/emergencycontact.dart';
import 'package:perisai_nusantara_app/page/laporan.dart';
import 'package:perisai_nusantara_app/page/login.dart';
import 'package:perisai_nusantara_app/page/selectsession.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.sessionMode = false}) : super(key: key);
  final bool sessionMode;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GetStorage session = GetStorage();
  late String tagId;
  late String isIn;
  late bool isDandru, sessionMode;

  void readAbsenNFC(String isCheckIn) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        tagId = tag.data['nfca']['identifier'].join();
        isIn = isCheckIn;
        NfcManager.instance.stopSession();
        postAttendace();
      });
      showDialog(
          context: context,
          builder: (context) => CustomDialogBox(
                title: 'Scanning ...',
                descriptions: 'Tempelkan pada Tag NFC',
                textButton: TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    NfcManager.instance.stopSession();
                    Get.back();
                  },
                ),
              ));
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
                  },
                ),
              ));
    }
  }

  Future postAttendace() async {
    final response = await http.post(Uri.parse(''),
        body: {'nik': session.read('nik'), 'tagid': tagId, 'checkin': isIn});
    if (response.statusCode == 200) {
      Get.back();
      Get.snackbar('Berhasil!', 'Absensi terunggah',
          backgroundColor: Colors.white);
    } else {
      Get.snackbar('Gagal', 'Silahkan hubungi developer',
          backgroundColor: Colors.white);
    }
  }

  @override
  void initState() {
    super.initState();
    isDandru = (session.read('idposition') != '2') ? false : true;
    this.sessionMode = widget.sessionMode;
    print(session.read('idposition'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: size.height * 0.27,
                width: size.width,
                color: const Color.fromARGB(255, 204, 9, 9),
              )
            ],
          ),
          Positioned(
              top: -80,
              left: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 204, 9, 9)),
              )),
          Positioned(
              top: 20,
              right: -10,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 204, 9, 9)),
              )),
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat Datang",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Perisai Nusantara GuardApp",
                            style: TextStyle(color: Colors.white, fontSize: 14))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(
                            //       ''),
                            // ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.read('name'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(session.read('site'))
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => SelectSession());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      /* FaIcon(
                                        FontAwesomeIcons.userClock,
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Ganti Sesi',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black45),
                                      ) */
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: sessionMode,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => SelectSession());
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.userClock,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      'Ganti Sesi',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black45),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: Colors.black45,
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  GetStorage().remove('nip');
                                  Get.offAll(Login());
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.blue[800]),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const FaIcon(
                                FontAwesomeIcons.angleRight,
                                size: 16,
                                color: Colors.black26,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  /* Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(
                      "Absensi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Absensi(
                        size: size,
                        title: 'Check In',
                        onTap: () {
                          readAbsenNFC("1");
                        },
                      ),
                      Absensi(
                        size: size,
                        title: 'Check Out',
                        onTap: () {
                          readAbsenNFC("0");
                        },
                      ),
                    ],
                  ), */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Text(
                          "Menu Anggota",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      /* Visibility(
                        visible: isDandru,
                        child: Row(
                          children: [
                            Text('Mode sesi: '),
                            Switch(
                                value: sessionMode,
                                onChanged: (value) {
                                  setState(() {
                                    sessionMode = value;
                                    print(widget.sessionMode);
                                    if (value) {
                                      session.write(
                                          "nip2", session.read('nip'));
                                      session.write(
                                          "name2", session.read('name'));
                                    } else {
                                      session.write(
                                          'nip', session.read('nip2'));
                                      session.write(
                                          'name', session.read('name2'));
                                    }
                                  });
                                }),
                          ],
                        ),
                      ) */
                    ],
                  ),
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      // padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                      children: <Widget>[
                        /* MainMenu(
                          icon: FaIcon(
                            FontAwesomeIcons.mapMarked,
                            color: Colors.orange[800],
                            size: 20,
                          ),
                          bgColor: Colors.orange.shade100,
                          title: "Patroli",
                          onTap: () {
                            Get.to(() => const CheckPointPage());
                          },
                        ), */
                        MainMenu(
                          icon: FaIcon(
                            FontAwesomeIcons.addressBook,
                            color: Colors.redAccent[800],
                            size: 20,
                          ),
                          bgColor: Colors.redAccent.shade100,
                          title: "Kontak Darurat",
                          onTap: () {
                            Get.to(() => const EmergencyContact());
                          },
                        ),
                        /* Visibility(
                          visible: isDandru,
                          child: Visibility(
                            visible: !sessionMode,
                            child: MainMenu(
                              icon: const FaIcon(
                                FontAwesomeIcons.book,
                                color: Colors.white,
                                size: 20,
                              ),
                              bgColor: Colors.red.shade900,
                              title: "Buku Tamu",
                              onTap: () {
                                Get.to(() => BukuTamu());
                              },
                            ),
                          ),
                        ), */
                        MainMenu(
                          icon: const FaIcon(
                            FontAwesomeIcons.book,
                            color: Colors.white,
                            size: 20,
                          ),
                          bgColor: Colors.red.shade900,
                          title: "Buku Tamu",
                          onTap: () {
                            Get.to(() => BukuTamu());
                          },
                        ),
                        MainMenu(
                          icon: FaIcon(
                            FontAwesomeIcons.bookJournalWhills,
                            color: Colors.blue[800],
                            size: 20,
                          ),
                          bgColor: Colors.blue.shade100,
                          title: "Buku Paket",
                          onTap: () {
                            Get.to(() => BukuPaket());
                          },
                        ),
                        MainMenu(
                          icon: FaIcon(
                            FontAwesomeIcons.userPlus,
                            color: Colors.blueAccent[800],
                            size: 20,
                          ),
                          bgColor: Colors.blueAccent.shade100,
                          title: "Jumlah Pengunjung",
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return Activities();
                                });
                          },
                        ),
                        MainMenu(
                          icon: FaIcon(
                            FontAwesomeIcons.infoCircle,
                            color: Colors.red[800],
                            size: 20,
                          ),
                          bgColor: Colors.red.shade100,
                          title: "Laporan",
                          onTap: () {
                            Get.to(() => Laporan());
                          },
                        ),
                        MainMenu(
                          icon: FaIcon(
                            FontAwesomeIcons.speakerDeck,
                            color: Colors.red[800],
                            size: 20,
                          ),
                          bgColor: Colors.red.shade100,
                          title: "Atensi",
                          onTap: () {
                            Get.to(() => null);
                          },
                        ),
                      ],
                    ),
                  ),
                  /* const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Text(
                      "Menu Danru",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ), */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Absensi extends StatelessWidget {
  const Absensi(
      {Key? key, required this.size, required this.title, required this.onTap})
      : super(key: key);

  final Size size;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.4,
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black87),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  final FaIcon icon;
  final String title;
  final Color bgColor;
  final void Function() onTap;
  const MainMenu({
    Key? key,
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
              child: icon,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: TextStyle(color: Colors.black45, fontSize: 12),
              ),
            )
          ],
        ),
        // color: Colors.red[100],
      ),
    );
  }
}
