import 'package:intl/intl.dart';
import 'package:memochat/data/profiles.dart';
import '../models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final _supabase = Supabase.instance.client;

  MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final user = _supabase.auth.currentUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.senderId == user?.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: ProfilesService.getEmoji(userId: message.senderId),
            builder: (context, snapshot) {
              return Text(
                (snapshot.data ?? ''),
                style: const TextStyle(fontSize: 24),
              );
            },
          ),
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
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.senderId == 'SupabaseService.userId'
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    DateFormat('HH:mm')
                        .format(message.createdAt ?? DateTime.now()),
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
