class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? oncreated;

  MessageModel({this.text, this.sender, this.seen, this.oncreated});

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    oncreated = map["oncreated"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "oncreated": oncreated
    };
  }
}
