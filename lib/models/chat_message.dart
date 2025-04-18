class ChatMessage {
  final String? id; // id nullable
  final String content;
  final String senderId;
  final DateTime? createdAt; // createdAt nullable
  final DateTime? updatedAt; // updatedAt nullable

  ChatMessage({
    this.id,
    required this.content,
    required this.senderId,
    this.createdAt,
    this.updatedAt,
  });
}