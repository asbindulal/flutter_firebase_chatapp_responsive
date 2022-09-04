import 'package:chatapp/pages/auth/login.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:chatapp/utility/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  var messageUser = user!.uid;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextEditingController message = TextEditingController();

    List<String> listUser = [
      "${user!.uid}+$messageUser",
      "$messageUser+${user!.uid}"
    ];
    return MediaQuery.of(context).size.width > 576
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Chat App'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const UserLogin(),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/chatapp/account/users')
                  .where(
                    'uid',
                    isNotEqualTo: user!.uid,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: size.width / 4),
                        decoration: MediaQuery.of(context).size.width > 576
                            ? BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 202, 202, 202)
                                            .withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                  ),
                                ],
                              )
                            : const BoxDecoration(
                                color: Colors.transparent,
                              ),
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    messageUser = doc['uid'];
                                  });
                                },
                                child: Container(
                                    color:
                                        doc['uid'] == messageUser ? red : grey,
                                    padding: const EdgeInsets.all(18),
                                    margin: const EdgeInsets.all(8),
                                    child: Text(doc['name'])),
                              );
                            }),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: size.width / 1.35),
                        child: messageUser != user!.uid
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection(
                                                '/chatapp/chat/messages')
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  DocumentSnapshot doc =
                                                      snapshot
                                                          .data!.docs[index];

                                                  return listUser.contains(
                                                          doc['users'])
                                                      ? Container(
                                                          color: doc['users'] ==
                                                                  "${user!.uid}+$messageUser"
                                                              ? blue
                                                              : grey,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Text(
                                                            doc['message'],
                                                          ),
                                                        )
                                                      : Container();
                                                });
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: TextFormField(
                                                  controller: message,
                                                  autofocus: false,
                                                  cursorColor: black,
                                                  decoration: InputDecoration(
                                                    hintText: 'Message',
                                                    fillColor: white,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        color: black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                  onSaved: (value) {
                                                    message.text = value!;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (message.text.isNotEmpty) {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        '/chatapp/chat/messages/')
                                                    .doc()
                                                    .set({
                                                  'message':
                                                      message.text.trim(),
                                                  'time': DateTime.now(),
                                                  'users':
                                                      "${user!.uid}+$messageUser",
                                                });

                                                message.clear();
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.send,
                                              size: 29,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Container(
                                  constraints:
                                      BoxConstraints(maxWidth: size.width / 2),
                                  child: const Text('Select User'),
                                ),
                              ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        : const HomePage();
  }
}
