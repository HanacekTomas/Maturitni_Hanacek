import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:slidovaci_apka/stranky/resit.dart';
import 'package:slidovaci_apka/stranky/nastaveni.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _stranka = 0;

  final stranky = [
    HomePage(),
    Resit(),
    Nastaveni(),
  ];

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Docházka"),
        ),
      body: Container(
        child:  Slidable(
          startActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: ((context){
                  //přítomen
                  print("Přítomen");
              }),
              backgroundColor: Colors.green,
              icon: Icons.check,
              ),
              SlidableAction(
                onPressed: ((context){
                  //pozdě/brzo
                  print("Pozdě/Brzo");
              }),
              backgroundColor: Color.fromARGB(255, 252, 183, 81),
              icon: Icons.alarm,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: ((context){
                  //nepřítomen
                  print("Nepřítomen");
              }),
              backgroundColor: Colors.red,
              icon: Icons.close,
              ),
            ],
          ),
          child: Container(
            color: Colors.grey[300],
            child: ListTile(
              title: Text("sdffsfs"),
              subtitle: Text("saftrčgrv"),
              leading: Icon(
                Icons.person,
                size: 40,
              ),
            ),
          ),
        ) ,
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _stranka,
      backgroundColor: Colors.blueGrey,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: "Docházka",
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: "Nevyřešené", 

            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Nastavení", 
            ),
        ],
        onTap: (index) {
          setState(() {
            _stranka = index;
          });
        },
        ),
    );
  }
}


