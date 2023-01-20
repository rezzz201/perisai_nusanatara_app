import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/selectabsensi.dart';
import 'package:perisai_nusantara_app/services/daftarabsenmodel.dart';

class ListAbsensi extends StatefulWidget {
  const ListAbsensi({Key? key}) : super(key: key);

  @override
  _ListAbsensiState createState() => _ListAbsensiState();
}

class _ListAbsensiState extends State<ListAbsensi> {
  String idsite = GetStorage().read('idsite');

  Future<List<ListAbsenModel>> getData() async {
    return ListAbsenService.get(idsite);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Absensi Hari Ini"),
        actions: [
          IconButton(
              onPressed: () {
                Get.off(() => SelectAbsensi());
              },
              icon: FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: Stack(
        children: [
          CustomBackground(),
          FutureBuilder<List<ListAbsenModel>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occurred!'),
                  );
                } else if (snapshot.hasData && snapshot.data!.length > 0) {
                  return AbsenList(listAbsen: snapshot.data!);
                } else if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return const Center(
                    child: Text(
                      'Belum ada absensi!',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}

class AbsenList extends StatelessWidget {
  const AbsenList({Key? key, required this.listAbsen}) : super(key: key);
  final List<ListAbsenModel> listAbsen;

  @override
  Widget build(BuildContext context) {
    List statusColor = [
      Colors.blue,
      Colors.blue[600],
      Colors.orange[800],
      Colors.blueGrey[700],
      Colors.lime[800],
      Colors.yellow[900],
      Colors.lightBlue[200],
      Colors.red[300],
      Colors.blueGrey[400],
      Colors.indigo[300],
      Colors.cyan[600],
      Colors.red,
      Colors.cyan[900],
      Colors.blueGrey[600],
      Colors.blueGrey[900],
      Colors.red[900],
      Colors.blueGrey,
      Colors.blueGrey,
      Colors.blueGrey
    ];
    return ListView.builder(
        itemCount: listAbsen.length,
        itemBuilder: (context, index) {
          ListAbsenModel data = listAbsen[index];
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
                  Text(
                    data.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Chip(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          backgroundColor:
                              statusColor[int.parse(data.attStatus)],
                          label: Text(
                            data.keterangan,
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )),
                      int.parse(data.hours) > 0
                          ? Chip(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 0),
                              backgroundColor: Colors.grey,
                              label: Text(
                                data.hours + ' jam',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ))
                          : SizedBox()
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
