class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel(this.uid, this.name, this.email);

  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel(map['uid'], map['name'], map['email']);
}

late UserModel user;
