import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/desktop.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:chatapp/utility/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return size.width < 576
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Chat App'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushReplacementNamed('/login');
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
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  messageUser: doc['uid'],
                                  userName: doc['name'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                              color: grey,
                              padding: const EdgeInsets.all(18),
                              margin: const EdgeInsets.all(8),
                              child: Text(doc['name'])),
                        );
                      });
                } else {
                  return Container();
                }
              },
            ),
          )
        : const DesktopHomePage();
  }
}
