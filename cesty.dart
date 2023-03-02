import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadytento/auth/autorizacni.dart';
import 'package:tadytento/stranky/hlavniStranka.dart';
import 'package:tadytento/auth/prihlaseni.dart';

class Cesty extends StatefulWidget {
  const Cesty({super.key});

  @override
  State<Cesty> createState() => _CestyState();
}

class _CestyState extends State<Cesty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HlavniStranka(
              nazevLekce: 'Lekce není vybraná',
            );
          } else {
            return Autorizacni();
          }
        },
      ),
    );
  }
}
