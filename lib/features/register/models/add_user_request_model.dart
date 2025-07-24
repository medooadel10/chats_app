class AddUserRequestModel {
  final String uid;
  final String name;
  final String email;

  AddUserRequestModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() => {'uid': uid, 'email': email, 'name': name};
}
