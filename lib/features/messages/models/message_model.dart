class MessageModel {
  final String id;
  final String content;
  final String receiverUid;
  final String senderUid;
  final String sendAt;

  MessageModel({
    required this.id,
    required this.content,
    required this.receiverUid,
    required this.senderUid,
    required this.sendAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) => MessageModel(
    id: data['id'],
    content: data['content'],
    receiverUid: data['receiverUid'],
    senderUid: data['senderUid'],
    sendAt: data['sendAt'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'content': content,
    'receiverUid': receiverUid,
    'senderUid': senderUid,
    'sendAt': sendAt,
  };
}
