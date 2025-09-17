class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) => UserModel(
    uid: data['uid'],
    name: data['name'],
    email: data['email'],
    phone: data['phone'],
  );
}
