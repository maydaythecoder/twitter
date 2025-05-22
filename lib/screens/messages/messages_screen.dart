import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Mock conversations data
  final List<Map<String, dynamic>> _conversations = [
    {
      'username': 'Elon Musk',
      'lastMessage': 'Hey, what do you think about the new AI developments?',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 5)),
      'unread': true,
    },
    {
      'username': 'Flutter Dev',
      'lastMessage': 'Thanks for the feedback on the app!',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'unread': false,
    },
    {
      'username': 'Tech News',
      'lastMessage': 'Would you like to be featured in our next article?',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'unread': false,
    },
  ];

  void _startNewMessage() {
    // In a real app, this would open a new message composer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New message feature coming soon!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // In a real app, this would open message settings
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                conversation['username'][0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    conversation['username'],
                    style: TextStyle(
                      fontWeight: conversation['unread']
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Text(
                  timeago.format(conversation['createdAt']),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              conversation['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: conversation['unread']
                    ? FontWeight.w500
                    : FontWeight.normal,
                color: conversation['unread']
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withAlpha(179),
              ),
            ),
            onTap: () {
              // In a real app, this would open the conversation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Opening conversation with ${conversation['username']}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewMessage,
        child: const Icon(Icons.mail_outline),
      ),
    );
  }
}
