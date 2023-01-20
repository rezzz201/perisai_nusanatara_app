import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/home.dart';
import 'package:perisai_nusantara_app/services/memberservice.dart';

class SelectSession extends StatefulWidget {
  const SelectSession({Key? key}) : super(key: key);

  @override
  _SelectSessionState createState() => _SelectSessionState();
}

class _SelectSessionState extends State<SelectSession> {
  String idsite = GetStorage().read('idsite');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Sesi Anggota'),
      ),
      body: Stack(
        children: [
          CustomBackground(),
          FutureBuilder<List<ListMemberModel>>(
            future: MemberService.get(idsite),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData && snapshot.data!.length > 0) {
                return MemberList(selectSession: snapshot.data!);
              } else {
                return Center(
                  child: Text(
                    'Tidak ada anggota.',
                    style: TextStyle(color: Colors.white38),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  const MemberList({Key? key, required this.selectSession}) : super(key: key);
  final List<ListMemberModel> selectSession;

  @override
  Widget build(BuildContext context) {
    GetStorage session = GetStorage();
    return ListView.builder(
        itemCount: selectSession.length,
        itemBuilder: (context, index) {
          ListMemberModel data = selectSession[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      session.write('nik', data.nik);
                      session.write('name', data.name);
                      Get.offAll(() => Home(
                            sessionMode: true,
                          ));
                    },
                    child: Text('Pilih'))
              ],
            ),
          );
        });
  }
}
