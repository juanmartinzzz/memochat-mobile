import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class MessagesService {
  static const String _baseUrl = 'https://future.endpoint';
  static const String _messagesKey = 'messages';

  /// Retrieves messages from local storage for a specific user and chapter
  static Future<List<ChatMessage>> getLocalMessages(
      String userId, String chapterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_messagesKey}_${userId}_$chapterId';
      final String? storedData = prefs.getString(key);

      if (storedData == null) return [];

      final List<dynamic> decodedData = json.decode(storedData);
      return decodedData
          .map((messageData) => ChatMessage(
                id: messageData['id'],
                sender: messageData['sender'],
                content: messageData['content'],
                timestamp: DateTime.parse(messageData['timestamp']),
                isMe: messageData['isMe'],
                senderAvatar: messageData['senderAvatar'],
              ))
          .toList();
    } catch (e) {
      print('Error retrieving local messages: $e');
      return [];
    }
  }

  /// Retrieves messages from the API for a specific user and chapter
  static Future<List<ChatMessage>> getApiMessages(
      String userId, String chapterId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/getMessages/$userId/$chapterId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load messages from API');
      }

      final List<dynamic> decodedData = json.decode(response.body);
      return decodedData
          .map((messageData) => ChatMessage(
                id: messageData['id'],
                sender: messageData['sender'],
                content: messageData['content'],
                timestamp: DateTime.parse(messageData['timestamp']),
                isMe: messageData['isMe'],
                senderAvatar: messageData['senderAvatar'],
              ))
          .toList();
    } catch (e) {
      print('Error retrieving API messages: $e');
      return [];
    }
  }

  /// Syncs messages between local storage and API, returns most recent 15 messages
  static Future<List<ChatMessage>> syncAndGetMessages(
      String userId, String chapterId) async {
    // Get messages from both sources
    final localMessages = await getLocalMessages(userId, chapterId);
    final apiMessages = await getApiMessages(userId, chapterId);

    // Find new messages from API that aren't in local storage
    final newMessages = apiMessages.where((apiMessage) =>
        !localMessages.any((localMessage) => localMessage.id == apiMessage.id));

    if (newMessages.isNotEmpty) {
      // Add new messages to local storage
      final prefs = await SharedPreferences.getInstance();
      final key = '${_messagesKey}_${userId}_$chapterId';
      final updatedMessages = [...localMessages, ...newMessages];

      // Convert messages to JSON and store
      final jsonData = json.encode(updatedMessages
          .map((msg) => {
                'id': msg.id,
                'sender': msg.sender,
                'content': msg.content,
                'timestamp': msg.timestamp.toIso8601String(),
                'isMe': msg.isMe,
                'senderAvatar': msg.senderAvatar,
              })
          .toList());

      await prefs.setString(key, jsonData);
    }

    // Combine and sort all messages by timestamp
    final allMessages = [...localMessages, ...newMessages];
    allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Return only the 15 most recent messages
    return allMessages.take(15).toList();
  }
}
