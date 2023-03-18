import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tadytento/stranky/editace.dart';
import 'package:tadytento/stranky/pridatCloveka.dart';

class NeniGDPR extends StatefulWidget {
  const NeniGDPR({super.key, required this.prihlasenyUzivatel});

  final String prihlasenyUzivatel;

  @override
  State<NeniGDPR> createState() => _NeniGDPRState();
}

class _NeniGDPRState extends State<NeniGDPR> {
  final jmenoController = TextEditingController();
  final prijmeniController = TextEditingController();
  final bydlisteController = TextEditingController();
  final kontakt1Controller = TextEditingController();
  final kontakt2Controller = TextEditingController();
  final zaplacenoController = TextEditingController();
  final poznamkaController = TextEditingController();
  final gdprController = TextEditingController();
  final krouzekController =  TextEditingController();

  late Stream<QuerySnapshot> zaseData = FirebaseFirestore.instance
      .collection('zaci')
      .where('gdpr', isEqualTo: 'false')
      .where('vytvorenoUctem', isEqualTo: widget.prihlasenyUzivatel)
      .snapshots();

  bool podminka = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chybí GDPR'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: zaseData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Něco je špatně");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Načítám");
            }

            final asiData = snapshot.requireData;

            return ListView.builder(
              itemCount: asiData.size,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                        '${asiData.docs[index]['jmeno']} ${asiData.docs[index]['prijmeni']}'),
                    subtitle: Text('${asiData.docs[index]['krouzek']}'),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditovaniCloveka(
                              poznamka: '${asiData.docs[index]['poznamka']}',
                              bydliste: '${asiData.docs[index]['bydliste']}',
                              jmeno: '${asiData.docs[index]['jmeno']}',
                              kontakt1: '${asiData.docs[index]['kontakt1']}',
                              kontakt2: '${asiData.docs[index]['kontakt2']}',
                              prijmeni: '${asiData.docs[index]['prijmeni']}',
                              zaplaceno: '${asiData.docs[index]['zaplaceno']}',
                              prihlasenyUzivatel: widget.prihlasenyUzivatel,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
