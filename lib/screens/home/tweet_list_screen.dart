import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/tweet.dart';
import '../../services/tweet_service.dart';
import '../../services/auth_service.dart';

class TweetListScreen extends StatefulWidget {
  const TweetListScreen({super.key});

  @override
  State<TweetListScreen> createState() => _TweetListScreenState();
}

class _TweetListScreenState extends State<TweetListScreen> {
  final TweetService _tweetService = TweetService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _addMockTweets();
  }

  Future<void> _addMockTweets() async {
    await _tweetService.addMockTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Tweet>>(
        stream: _tweetService.getTweetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tweets = snapshot.data ?? [];

          if (tweets.isEmpty) {
            return const Center(child: Text('No tweets yet'));
          }

          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              final tweet = tweets[index];
              final isLiked =
                  tweet.likedBy.contains(_authService.currentUser?.uid);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: Text(tweet.username[0]),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tweet.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                timeago.format(tweet.createdAt),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(tweet.content),
                      if (tweet.imageUrl != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            tweet.imageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () => _tweetService.toggleLike(tweet.id),
                          ),
                          Text('${tweet.likes}'),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.repeat),
                            onPressed: () => _tweetService.retweet(tweet.id),
                          ),
                          Text('${tweet.retweets}'),
                          const Spacer(),
                          if (tweet.userId == _authService.currentUser?.uid)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _tweetService.deleteTweet(tweet.id),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              final textController = TextEditingController();
              String? imageUrl;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: textController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "What's happening?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: () {
                            // TODO: Implement image upload
                            imageUrl = 'https://picsum.photos/500/300';
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              _tweetService.createTweet(
                                content: textController.text,
                                imageUrl: imageUrl,
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Tweet'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tweet creation coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
