import 'package:firebase_auth/firebase_auth.dart';
import 'package:prihlasovani/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Docházka');
  }

  Color _barva = Colors.red;

  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                  title: Text('❌'),
                  tileColor: _barva,
                  onTap: () {
                    if (_barva == Colors.red) {
                      setState(() {
                        _barva = Colors.green;
                      });
                    }
                  },
                  onLongPress: () {}),
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
