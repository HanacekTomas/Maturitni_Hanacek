import 'package:flutter/material.dart';

class Dochazka extends StatelessWidget {
  const Dochazka({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 185, 185, 185),
        appBar: AppBar(
          title: const Text("Docházka"),
          actions: [
            Icon(Icons.more_horiz),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
            ),
          ],
        ),
        body: ListView(
          children: [
            Card(
                child: ListTile(
              title: Text("Docházka 1"),
              trailing: Icon(Icons.navigate_next),
            )),
            Card(
              child: ListTile(
                title: Text("Docházka 2"),
                trailing: Icon(Icons.navigate_next),
              ),
            ),
            Card(
                child: ListTile(
              title: Text("Docházka 3"),
              trailing: Icon(Icons.navigate_next),
            )),
          ],
          shrinkWrap: true,
        ),

        //tlačítko přidat
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              print("Ahoj");
            }),
      ),
    );
  }
}

class Dochazkovy extends StatefulWidget {
  const Dochazkovy({super.key});

  @override
  State<Dochazkovy> createState() => _Dochazkovy();
}

class _Dochazkovy extends State<Dochazkovy> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Docházka',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Lidé',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Nevyřešené',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Nastavení',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
