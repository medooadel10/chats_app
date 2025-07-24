class MessageModel {
  final String id;
  final String messageContent;
  final String senderUid;
  final String receiverUid;
  final String sentAt;
  final String receiverName;
  final String receiverEmail;
  final String senderName;
  final String senderEmail;
  MessageModel({
    required this.id,
    required this.messageContent,
    required this.senderUid,
    required this.receiverUid,
    required this.sentAt,
    required this.receiverEmail,
    required this.receiverName,
    required this.senderEmail,
    required this.senderName,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
    id: map['id'],
    messageContent: map['messageContent'],
    senderUid: map['senderUid'],
    receiverUid: map['receiverUid'],
    sentAt: map['sentAt'],
    receiverEmail: map['receiverEmail'],
    receiverName: map['receiverName'],
    senderEmail: map['senderEmail'],
    senderName: map['senderName'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'messageContent': messageContent,
    'senderUid': senderUid,
    'receiverUid': receiverUid,
    'sentAt': sentAt,
    'receiverEmail': receiverEmail,
    'receiverName': receiverName,
    'senderEmail': senderEmail,
    'senderName': senderName,
  };
}
