class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? oncreated;

  MessageModel(
      {this.messageId, this.text, this.sender, this.seen, this.oncreated});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    oncreated = map["oncreated"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "oncreated": oncreated
    };
  }
}
