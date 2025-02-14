class ChatMessage {
  final String id;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final String senderAvatar;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.isMe,
    required this.senderAvatar,
  });
}