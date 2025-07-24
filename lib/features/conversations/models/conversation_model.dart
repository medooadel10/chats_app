class ConversationModel {
  final String uid;
  final String name;
  final String email;

  ConversationModel(this.uid, this.name, this.email);

  factory ConversationModel.fromMap(Map<String, dynamic> data) =>
      ConversationModel(data['uid'], data['name'], data['email']);
}
