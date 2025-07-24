class AddMessageRequestModel {
  final String id;
  final String messageContent;
  final String senderUid;
  final String receiverUid;
  final String sentAt;

  AddMessageRequestModel({
    required this.id,
    required this.messageContent,
    required this.senderUid,
    required this.receiverUid,
    required this.sentAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'messageContent': messageContent,
    'senderUid': receiverUid,
    'receiverUid': senderUid,
    'sentAt': sentAt,
  };
}
