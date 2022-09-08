import 'package:chatapp/utility/constant.dart';
import 'package:chatapp/utility/firebase.dart';
import 'package:chatapp/utility/usermodal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

String? messageUserUid;
String? messageUsername;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("/chatapp/account/users")
        .doc(user!.uid)
        .get()
        .then((value) {
      currentUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  String? messageUserUid;
  String? messageUsername;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: size.width > 576
          ? AppBar(
              backgroundColor: blue,
              elevation: 0,
              title: Text(
                'Chats',
                style: googleFonts(
                  fs: fontSizeAppBar,
                  color: black,
                  fw: FontWeight.w500,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: black,
              ),
              leading: Container(
                margin: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: blue,
                  backgroundImage: NetworkImage(
                    "${currentUser.avatar}",
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    });
                  },
                  icon: const Icon(
                    LineIcons.alternateSignOut,
                  ),
                ),
              ],
            )
          : null,
      body: size.width > 576
          ? Row(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: size.width / 5),
                  child: StreamBuilder(
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

                              return Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      messageUserUid = doc['uid'];
                                      messageUsername = doc['name'];
                                    });
                                  },
                                  tileColor: doc['uid'] == messageUserUid
                                      ? red
                                      : white,
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      doc['avatar'],
                                    ),
                                  ),
                                  title: Text(
                                    doc['name'],
                                    style: googleFonts(
                                      fs: fontSizetitle,
                                      fw: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Latest Message',
                                    style: googleFonts(
                                      color: darkGrey,
                                      fs: fontSizeSubtitle,
                                      fw: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  constraints:
                      BoxConstraints(maxWidth: size.width - size.width / 5),
                  child: (messageUserUid.toString() == "null")
                      ? Center(
                          child: Text(
                            "Select Users",
                            style: googleFonts(
                              fs: fontSizeAppBar,
                            ),
                          ),
                        )
                      : ChatPage(
                          messageUser: "$messageUserUid",
                          userName: "$messageUsername",
                        ),
                ),
              ],
            )
          : const UserListChat(),
    );
  }
}

class UserListChat extends StatelessWidget {
  const UserListChat({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        title: Text(
          'Chats',
          style: googleFonts(
            fs: fontSizeAppBar,
            color: black,
            fw: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: black,
        ),
        leading: Container(
          margin: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: blue,
            backgroundImage: NetworkImage(
              "${currentUser.avatar}",
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
            },
            icon: const Icon(
              LineIcons.alternateSignOut,
            ),
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

                  return StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                          tileColor: white,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              doc['avatar'],
                            ),
                          ),
                          title: Text(
                            doc['name'],
                            style: googleFonts(
                              fs: fontSizetitle,
                              fw: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Latest Message',
                            style: googleFonts(
                              color: darkGrey,
                              fs: fontSizeSubtitle,
                              fw: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                      ;
                    },
                  );
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

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
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        elevation: 0,
        title: Text(
          userName,
          style: googleFonts(
            fs: fontSizeAppBar,
            color: black,
            fw: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: black,
        ),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(
              LineIcons.infoCircle,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('/chatapp/chat/messages')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];

                        Timestamp timeStamp = doc['time'];
                        DateTime dateTime = timeStamp.toDate();
                        String time = "${dateTime.hour}:${dateTime.minute}";

                        return listUser.contains(doc['users'])
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    doc['users'] == "${user!.uid}+$messageUser"
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  doc['users'] == "${user!.uid}+$messageUser"
                                      ? Text(
                                          time,
                                          style: googleFonts(
                                            fs: fontSize,
                                            color: darkGrey,
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: doc['users'] ==
                                                "${user!.uid}+$messageUser"
                                            ? blue
                                            : white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: const EdgeInsets.all(18),
                                    margin: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: doc['users'] ==
                                              "${user!.uid}+$messageUser"
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc['message'],
                                          style: googleFonts(
                                            fs: fontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  doc['users'] != "${user!.uid}+$messageUser"
                                      ? Text(
                                          time,
                                          style: googleFonts(
                                            fs: fontSize,
                                            color: darkGrey,
                                          ),
                                        )
                                      : Container(),
                                ],
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
            child: Form(
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
          ),
        ],
      ),
    );
  }
}
