import 'package:intl/intl.dart';
import '../models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.senderId == 'SupabaseService.userId' ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (message.senderId != 'SupabaseService.userId') ...[
            Text(
              message.senderAvatar,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: message.senderId == 'SupabaseService.userId'
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.senderId != 'SupabaseService.userId')
                    Text(
                      message.senderAvatar,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          color: message.senderId == 'SupabaseService.userId'
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.senderId == 'SupabaseService.userId'
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm').format(message.createdAt ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      color: message.senderId == 'SupabaseService.userId'
                          ? Colors.white70
                          : Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.senderId == 'SupabaseService.userId') ...[
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}