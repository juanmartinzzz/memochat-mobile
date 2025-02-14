import 'package:flutter/material.dart';
import 'package:memochat/data/constants.dart';
// import 'package:memochat/data/groups.dart';
import 'package:memochat/data/messages.dart';
import 'package:memochat/models/chat_message.dart';
// import 'package:memochat/models/group.dart';
import 'package:memochat/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final Chapter chapter;
  const ChatScreen({super.key, required this.chapter});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isRecording = false;
  List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();

  Future<void> _loadMessages() async {
    // await MessagesService.clearLocalMessages("IOU real User ID", widget.chapter.id);
    messages = await MessagesService.syncAndGetMessages("IOU real User ID", widget.chapter.id);
    setState(() {}); // Update the UI after loading messages
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();

    // GroupsService.addGroup(Group(
    //   id: widget.chapter.id,
    //   name: widget.chapter.name,
    //   description: widget.chapter.description,
    //   creatorId: 'IOU real User ID',
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.name),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              final messageContent = _messageController.text.trim();
              if (messageContent.isNotEmpty) {
                final newMessage = ChatMessage(
                  senderId: 'currentUserId', // Replace with actual user ID
                  content: messageContent,
                  senderAvatar: '⭐️', // Replace with actual avatar URL
                );
                await MessagesService.addMessage(widget.chapter.id, newMessage);
                _messageController.clear(); // Clear input field
                _loadMessages();
              }
            },
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isRecording = !_isRecording;
              });
            },
            icon: Icon(
              _isRecording ? Icons.stop : Icons.mic,
              color: _isRecording
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
