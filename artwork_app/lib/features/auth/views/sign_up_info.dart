import 'package:artwork_app/common/colors.dart';
import 'package:artwork_app/features/auth/controller/auth_controller.dart';
import 'package:artwork_app/features/home/views/home.dart';
import 'package:artwork_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpInfo extends StatefulWidget {
  const SignUpInfo({
    Key? key,
    required this.email,
  }) : super(key: key);
  
  final String email;

  @override
  State<SignUpInfo> createState() => _SignUpInfoState();
}

class _SignUpInfoState extends State<SignUpInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sign.jpg'), // Fotoğrafın yolu burada belirtilmeli
                fit: BoxFit.cover,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xCC291C3C), // Kutucuk rengini biraz şeffaf siyah olarak ayarladık
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Sign Up Info",
                            style: TextStyle(
                              color: Colors.lightGreenAccent, // Yazı rengini açık yeşil olarak ayarladık
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Name is required.";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              labelText: "Name",
                              labelStyle: const TextStyle(color: Colors.lightGreenAccent), // Label rengini açık yeşil olarak ayarladık
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white, // Kutucuk kenar rengini beyaz olarak ayarladık
                                ),
                              ),
                            ),
                            style: const TextStyle(color: Colors.lightGreenAccent), // Metin rengini açık yeşil olarak ayarladık
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: _surnameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Surname is required.";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              labelText: "Surname",
                              labelStyle: const TextStyle(color: Colors.lightGreenAccent), // Label rengini açık yeşil olarak ayarladık
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white, // Kutucuk kenar rengini beyaz olarak ayarladık
                                ),
                              ),
                            ),
                            style: const TextStyle(color: Colors.lightGreenAccent), // Metin rengini açık yeşil olarak ayarladık
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: _usernameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Username is required.";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              labelText: "Username",
                              labelStyle: const TextStyle(color: Colors.lightGreenAccent), // Label rengini açık yeşil olarak ayarladık
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white, // Kutucuk kenar rengini beyaz olarak ayarladık
                                ),
                              ),
                            ),
                            style: const TextStyle(color: Colors.lightGreenAccent), // Metin rengini açık yeşil olarak ayarladık
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    UserModel userModel = UserModel(
                                      name: _nameController.text,
                                      surname: _surnameController.text,
                                      email: widget.email,
                                      username: _usernameController.text,
                                    );
                                    ref
                                        .read(authControllerProvider)
                                        .storeUserInfoToFirebase(userModel)
                                        .then((_) {
                                      FirebaseAuth.instance.currentUser!
                                          .sendEmailVerification();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const Home(),
                                        ),
                                        (route) => false,
                                      );
                                    });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: signInButtonColor,
                                minWidth: double.infinity,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}