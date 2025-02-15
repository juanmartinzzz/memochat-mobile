import 'dart:convert';
import '../models/chat_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesService {
  static const String _messagesKey = 'messages';

  /// Add a message to remote DB
  static Future<void> addMessage({required String chapterId, required ChatMessage message}) async {
    try {
      await Supabase.instance.client
          .from('chat_messages')
          .insert({
            'group_id': chapterId,
            'content': message.content,
            'sender_id': message.senderId,
            'sender_avatar': message.senderAvatar,
          });
    } catch (e) {
      print('Error sending message to API: $e');
    }
  }

  /// Cleans all local messages for a specific group
  static Future<void> clearLocalMessages({required String chapterId}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_messagesKey}_$chapterId';
    await prefs.remove(key);
  }

  /// Retrieves messages from local storage for a specific chapter
  static Future<List<ChatMessage>> getLocalMessages({required String chapterId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_messagesKey}_$chapterId';
      final String? storedData = prefs.getString(key);

      if (storedData == null) return [];

      final List<dynamic> decodedData = json.decode(storedData);
      return decodedData
          .map((messageData) => ChatMessage(
                id: messageData['id'],
                senderId: messageData['senderId'],
                content: messageData['content'],
                senderAvatar: messageData['senderAvatar'],
                createdAt: DateTime.parse(messageData['createdAt']),
                updatedAt: DateTime.parse(messageData['updatedAt']),
              ))
          .toList();
    } catch (e) {
      print('Error retrieving local messages: $e');
      return [];
    }
  }

  /// Retrieves messages from the API for a specific user and chapter
  static Future<List<ChatMessage>> getRemoteMessages({required String chapterId}) async {
    String firstMessage = 'Initial value';
    try {
      final data = await Supabase.instance.client
          .from('chat_messages')
          .select()
          .eq('group_id', chapterId);

      return data
          .map((messageData) => ChatMessage(
                id: messageData['id'] ?? '',
                senderId: messageData['sender_id'] ?? '',
                content: messageData['content'] ?? '',
                createdAt: DateTime.parse(messageData['created_at'] ?? DateTime.now().toIso8601String()),
                updatedAt: DateTime.parse(messageData['updated_at'] ?? DateTime.now().toIso8601String()),
                senderAvatar: messageData['sender_avatar'] ?? '',
              ))
          .toList();
    } catch (e) {
      firstMessage = 'Error retrieving messages: $e';
      print('Error retrieving messages: $e');
      return [
        ChatMessage(id: '11', senderId: 'FunnyBot', content: firstMessage, createdAt: DateTime.now().subtract(const Duration(minutes: 27)), updatedAt: DateTime.now(), senderAvatar: '👩',),
      ];
    }
  }

  /// Syncs messages between local storage and API, returns most recent 15 messages
  static Future<List<ChatMessage>> syncAndGetMessages({required String chapterId, bool bypassRemote = false, bool bypassLocal = false}) async {
    if (bypassLocal) {
      // If bypassLocal is true, only get messages from the API
      final remoteMessages = await getRemoteMessages(chapterId: chapterId);
      remoteMessages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      return remoteMessages.toList();
    }

    // Get messages from both sources
    final localMessages = await getLocalMessages(chapterId: chapterId);
    List<ChatMessage> remoteMessages = [];

    if(!bypassRemote) {
      remoteMessages = await getRemoteMessages(chapterId: chapterId);
    }

    // Find new messages from API that aren't in local storage
    final newMessages = remoteMessages.where((apiMessage) =>
        !localMessages.any((localMessage) => localMessage.id == apiMessage.id));

    if (newMessages.isNotEmpty) {
      // Add new messages to local storage
      final prefs = await SharedPreferences.getInstance();
      final key = '${_messagesKey}_$chapterId';
      final updatedMessages = [...localMessages, ...newMessages];

      // Convert messages to JSON and store
      final jsonData = json.encode(updatedMessages
          .map((msg) => {
                'id': msg.id,
                'senderId': msg.senderId,
                'content': msg.content,
                'createdAt': msg.createdAt?.toIso8601String(),
                'updatedAt': msg.updatedAt?.toIso8601String(),
                'senderAvatar': msg.senderAvatar,
              })
          .toList());

      await prefs.setString(key, jsonData);
    }

    // Combine and sort all messages by timestamp
    final allMessages = [...localMessages, ...newMessages];
    allMessages.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    // Return messages
    return allMessages.toList();
  }
}
