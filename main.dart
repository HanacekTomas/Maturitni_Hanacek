import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tadytento/auth/prihlaseni.dart';

import 'auth/cesty.dart';
import 'auth/obnovaHesla.dart';
import 'auth/registrace.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Uvodni());
}

class Uvodni extends StatelessWidget {
  const Uvodni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Cesty(),
    );
  }
}

class Barvy {
  static Color snackbarText = Colors.white;
  static Color snackbarCervena = Colors.red;
  static Color snackbarZelena = Colors.green;
  static Color barvaTlacitkaOdstranit = Colors.red;
  static Color barvaAktivnihoTlacitka = Colors.green;
  static Color nedoplnenaInfo = Colors.red;
  static Color gdprPovoleno = Colors.green;
  static Color gdprZakazano = Colors.red;
  static Color neniPodklad = Color.fromARGB(255, 223, 166, 166);
  static Color jePodklad = Color.fromARGB(255, 162, 220, 175);
  static Color bilaPodklad = Colors.white;
  static Color neniFajfka = Color.fromARGB(255, 0, 134, 4);
  static Color jeKrizek = Color.fromARGB(255, 154, 18, 8);
  static Color fialova = Colors.deepPurple;
  static Color seda = Colors.grey;
}
