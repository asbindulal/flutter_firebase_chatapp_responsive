import 'package:chatapp/pages/desktop.dart';
import 'package:chatapp/utility/constant.dart';
import 'package:chatapp/utility/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    required this.messageUser,
    required this.userName,
  });
  String messageUser;
  String userName;

  @override
  Widget build(BuildContext context) {
    TextEditingController message = TextEditingController();

    List<String> listUser = [
      "${user!.uid}+$messageUser",
      "$messageUser+${user!.uid}"
    ];
    var size = MediaQuery.of(context).size;
    return size.width < 576
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(userName),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('/chatapp/chat/messages')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];

                              return listUser.contains(doc['users'])
                                  ? Container(
                                      color: doc['users'] ==
                                              "${user!.uid}+$messageUser"
                                          ? blue
                                          : grey,
                                      padding: const EdgeInsets.all(18),
                                      margin: const EdgeInsets.all(8),
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
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: message,
                              autofocus: false,
                              cursorColor: black,
                              decoration: InputDecoration(
                                hintText: 'Message',
                                fillColor: white,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
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
                                .collection('/chatapp/chat/messages/')
                                .doc()
                                .set({
                              'message': message.text.trim(),
                              'time': DateTime.now(),
                              'users': "${user!.uid}+$messageUser",
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
        : const DesktopHomePage();
  }
}
