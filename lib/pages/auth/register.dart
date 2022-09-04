import 'package:chatapp/pages/auth/login.dart';
import 'package:chatapp/pages/desktop.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegister extends StatelessWidget {
  const UserRegister({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: MediaQuery.of(context).size.width > 576
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                )
              : const BoxDecoration(
                  color: Colors.transparent,
                ),
          margin: const EdgeInsets.all(12),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    textScaleFactor: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: customFormFeild(
                      labelText: 'name',
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      controller: name,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: customFormFeild(
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      controller: email,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: customFormFeild(
                      controller: password,
                      labelText: 'Password',
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return MaterialButton(
                          onPressed: () async {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email.text, password: password.text)
                                .then((value) {
                              FirebaseFirestore.instance
                                  .collection("/chatapp/account/users")
                                  .doc(value.user!.uid)
                                  .set({
                                'uid': value.user!.uid,
                                'name': name.text,
                                'email': email.text,
                              }).then((value) {
                                email.clear();
                                name.clear();
                                password.clear();
                              });

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const DesktopHomePage(),
                                ),
                              );
                            });
                          },
                          color: Colors.amber,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Register'),
                          ),
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const UserLogin(),
                        ),
                      );
                    },
                    child: const Text('login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  customFormFeild({
    controller,
    labelText,
    keyboardType,
    textInputAction,
    obscureText,
  }) {
    return TextFormField(
      autofocus: false,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: black,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
