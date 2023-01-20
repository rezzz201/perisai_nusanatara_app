import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/page/components/dialogactivitydetail.dart';
import 'package:perisai_nusantara_app/page/components/dialogaddactivity.dart';
import 'package:perisai_nusantara_app/services/activityservice.dart';
import 'package:intl/intl.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  String idsite = GetStorage().read('idsite');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktifitas'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => DialogAddActivity());
              },
              icon: const FaIcon(FontAwesomeIcons.plus))
        ],
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          FutureBuilder<List<AcitivityModel>>(
            future: ActivityServices.getData(idsite),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData && snapshot.data!.length > 0) {
                return ActivityList(activities: snapshot.data!);
              } else {
                return Center(
                  child: Text(
                    'Tambah Aktifitas',
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

class ActivityList extends StatelessWidget {
  const ActivityList({Key? key, required this.activities}) : super(key: key);
  final List<AcitivityModel> activities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          AcitivityModel data = activities[index];
          return GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (context) => DialogActivityDetail(
                      image: data.images,
                      name: data.name,
                      activity: data.activity,
                    )),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Column(
                children: [
                  Text(
                    data.activity,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('ditambahkan pada ' +
                      DateFormat('kk:mm').format(data.dateTime))
                ],
              ),
            ),
          );
        });
  }
}
