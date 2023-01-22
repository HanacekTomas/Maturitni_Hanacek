import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Registrace extends StatefulWidget {
  final VoidCallback ukazPrihlaseni;
  const Registrace({Key? key, required this.ukazPrihlaseni}) : super(key: key);

  @override
  State<Registrace> createState() => _RegistraceState();
}

class _RegistraceState extends State<Registrace> {
  final _emailController = new TextEditingController();
  final _hesloController = new TextEditingController();
  final _spravneHesloController = new TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _hesloController.dispose();
    _spravneHesloController.dispose();
    super.dispose();
  }

  Future registrace() async {
    if (hesloSpravne()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _hesloController.text.trim());
    }
  }

  bool hesloSpravne() {
    if (_hesloController.text.trim() == _spravneHesloController.text.trim()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Hesla se neshodují")));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'REGISTRACE',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 35,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _spravneHesloController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      hintText: 'Heslo',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _hesloController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      hintText: 'Heslo znovu',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: registrace,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Registrovat',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Již máte účet?',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.ukazPrihlaseni,
                      child: Text('Přihlaste se'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
