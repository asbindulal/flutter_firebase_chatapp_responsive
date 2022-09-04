import 'package:chatapp/pages/auth/register.dart';
import 'package:chatapp/pages/desktop.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
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
                    'Login',
                    textScaleFactor: 1.5,
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
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text)
                                .then((value) {
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
                            child: Text('Login'),
                          ),
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const UserRegister(),
                        ),
                      );
                    },
                    child: const Text('Register'),
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
