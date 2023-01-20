import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/customdialog.dart';
import 'package:perisai_nusantara_app/services/listtageservice.dart';
import 'package:http/http.dart' as http;

Future postTag(String nfcid, String tagid) async {
  print(nfcid);
  print(tagid);
  final response = await http.post(
      Uri.parse('https://hris.tpm-facility.com/attendance/addtag'),
      body: {'nfcid': nfcid, 'tagid': tagid});
  if (response.statusCode == 200) {
    Get.back();
    Get.snackbar('Berhasil!', 'Tag diperbarui', backgroundColor: Colors.white);
  } else {
    Get.snackbar('Gagal', 'Silahkan hubungi developer',
        backgroundColor: Colors.white);
  }
}

class SetTag extends StatefulWidget {
  SetTag({Key? key}) : super(key: key);

  @override
  State<SetTag> createState() => _SetTagState();
}

class _SetTagState extends State<SetTag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar ID Tag")),
      body: Stack(
        children: [
          CustomBackground(),
          FutureBuilder<List<ListTagsModel>>(
              future: ListTagService.get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occurred!'),
                  );
                } else if (snapshot.hasData && snapshot.data!.length > 0) {
                  return TagList(listTag: snapshot.data!);
                } else if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Belum ada tag!',
                        style: TextStyle(color: Colors.white)),
                  );
                } else {
                  return const Center(
                    child: Text('Belum ada tag!',
                        style: TextStyle(color: Colors.white)),
                  );
                }
              })
        ],
      ),
    );
  }
}

class TagList extends StatefulWidget {
  const TagList({Key? key, required this.listTag}) : super(key: key);
  final List<ListTagsModel> listTag;

  @override
  State<TagList> createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  late String tagId;

  get http => null;
  void readNFC(String nfcid) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        tagId = tag.data['nfca']['identifier'].join();
        NfcManager.instance.stopSession();
        Get.back();
        print(tagId);
        postTag(nfcid, tagId);
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.listTag.length,
        itemBuilder: (context, index) {
          ListTagsModel data = widget.listTag[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.label,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.site,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      readNFC(data.nfcid);
                    },
                    child: data.tagid == null
                        ? Chip(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            backgroundColor: Colors.red[700],
                            label: Text(
                              "scan tag",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ))
                        : Chip(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            backgroundColor: Colors.red[300],
                            label: Text(
                              "update",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
