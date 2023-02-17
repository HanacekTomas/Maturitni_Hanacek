import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ZapsaniDochazky extends StatefulWidget {
  const ZapsaniDochazky(
      {Key? key, required this.datumDochazky, required this.nazevLekce})
      : super(key: key);

  final String datumDochazky;
  final String nazevLekce;
  @override
  State<ZapsaniDochazky> createState() => _ZapsaniDochazkyState();
}

class _ZapsaniDochazkyState extends State<ZapsaniDochazky> {
  late Stream<QuerySnapshot> zapsaniDochazkyData =
      FirebaseFirestore.instance.collection('zaci').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.datumDochazky),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: zapsaniDochazkyData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Něco je špatně");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Načítám");
            }

            final dochazkoveData = snapshot.requireData;

            return ListView.builder(
              itemCount: dochazkoveData.size,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']}'),
                  tileColor: Colors.white,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']} je přítomen")));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "${dochazkoveData.docs[index]['jmeno']} ${dochazkoveData.docs[index]['prijmeni']} není přítomen")));
                          FirebaseFirestore.instance
                              .collection('dochazka')
                              .doc(
                                  '${widget.datumDochazky} - ${widget.nazevLekce}')
                              .set({
                                
                          });
                        },
                      ),
                    ],
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
