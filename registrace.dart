import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool schovatHeslo = true;
  String errorZprava = '';

  @override
  void dispose() {
    _emailController.dispose();
    _hesloController.dispose();
    _spravneHesloController.dispose();
    super.dispose();
  }

  Future registrace() async {
    try {
      if (hesloSpravne()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _hesloController.text.trim(),
        );
      }
      errorZprava = '';
    } on FirebaseAuthException catch (error) {
      errorZprava = error.message!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: errorZprava == errorZprava
            ? Text('Uživatelský účet již existuje')
            : Text('Uživatelský účet již existuje'),
        backgroundColor: Color.fromARGB(255, 187, 12, 0),
      ));
    }
  }

  bool hesloSpravne() {
    if (_hesloController.text.trim() == _spravneHesloController.text.trim()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Hesla se neshodují"),
        backgroundColor: Color.fromARGB(255, 187, 12, 0),
      ));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 121, 77, 197),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    'REGISTRACE',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 35,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        hintText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _spravneHesloController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        hintText: 'Heslo',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      obscureText: schovatHeslo,
                      controller: _hesloController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            if (schovatHeslo == false) {
                              setState(() {
                                schovatHeslo = true;
                              });
                            } else {
                              setState(() {
                                schovatHeslo = false;
                              });
                            }
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        hintText: 'Heslo znovu',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
                    height: MediaQuery.of(context).size.height * 0.05,
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
      ),
    );
  }
}
