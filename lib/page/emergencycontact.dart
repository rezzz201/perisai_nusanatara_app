import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perisai_nusantara_app/page/components/background.dart';
import 'package:perisai_nusantara_app/services/emergencycontactservice.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({Key? key}) : super(key: key);

  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak Darurat'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Stack(
        children: [
          const CustomBackground(),
          FutureBuilder<List<ContactModel>>(
            future: ContactServices.getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              } else if (snapshot.hasData) {
                return ContactList(contacts: snapshot.data!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class ContactList extends StatelessWidget {
  const ContactList({Key? key, required this.contacts}) : super(key: key);

  final List<ContactModel> contacts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          ContactModel data = contacts[index];
          return GestureDetector(
            onTap: () async {
              await canLaunch("tel:${data.notelepon}")
                  ? await launch("tel:${data.notelepon}")
                  : throw 'Could not launch tel';
            },
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.addressBook,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.service,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(data.notelepon)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
