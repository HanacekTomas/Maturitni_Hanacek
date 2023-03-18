import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tadytento/stranky/editace.dart';
import 'package:tadytento/stranky/pridatCloveka.dart';

class Nezaplaceno extends StatefulWidget {
  const Nezaplaceno({super.key, required this.prihlasenyUzivatel});

  final String prihlasenyUzivatel;

  @override
  State<Nezaplaceno> createState() => _NezaplacenoState();
}

class _NezaplacenoState extends State<Nezaplaceno> {
  final jmenoController = new TextEditingController();
  final prijmeniController = new TextEditingController();
  final bydlisteController = new TextEditingController();
  final kontakt1Controller = new TextEditingController();
  final kontakt2Controller = new TextEditingController();
  final zaplacenoController = new TextEditingController();
  final poznamkaController = new TextEditingController();
  final gdprController = new TextEditingController();
  final krouzekController = new TextEditingController();

  late Stream<QuerySnapshot> zaseData = FirebaseFirestore.instance
      .collection('zaci')
      .where('zaplaceno', isEqualTo: '')
      .where('vytvorenoUctem', isEqualTo: widget.prihlasenyUzivatel)
      .snapshots();

  bool podminka = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nezaplaceno'),
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
