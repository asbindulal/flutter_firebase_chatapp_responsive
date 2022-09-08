class UserModel {
  String? uid;
  String? email;
  String? name;
  String? avatar;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.avatar,
  });
  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      avatar: map['avatar'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'avatar': avatar,
    };
  }
}
