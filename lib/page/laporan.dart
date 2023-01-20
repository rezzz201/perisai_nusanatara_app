import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/dialogaddlaporan.dart';
import 'package:perisai_nusantara_app/page/components/dialoglaporandetail.dart';
import 'package:perisai_nusantara_app/services/laporanservice.dart';
import 'package:intl/intl.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  _LaporanState createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  String laporanid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => const DialogAddLaporan());
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          FutureBuilder<List<LaporanModel>>(
            future: LaporanServices.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint('$snapshot.error');
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return LaporanList(laporan: snapshot.data!);
              } else {
                return const Center(
                  child: Text(
                    'Tambahkan Laporan Hari ini',
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

class LaporanList extends StatelessWidget {
  const LaporanList({Key? key, required this.laporan}) : super(key: key);
  final List<LaporanModel> laporan;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: laporan.length,
        itemBuilder: (context, index) {
          LaporanModel data = laporan[index];
          return GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) => DialogLaporanDetail(
                      nama: data.nama,
                      laporan: data.laporan, 
                      //foto: 'images.png',
                    )),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.laporan,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Dilaporkan ${data.nama} pada ${data.tanggal}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}