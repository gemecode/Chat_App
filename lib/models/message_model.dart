class MessageModel {
  final String message;
  final String email;

  MessageModel(
    this.message,
    this.email,
  );

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      jsonData['message'],
      jsonData['email'],
    );
  }
}
