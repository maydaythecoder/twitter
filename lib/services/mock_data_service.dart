import 'package:twitter/models/tweet.dart';

class MockDataService {
  static final List<Tweet> tweets = [
    Tweet(
      id: '1',
      userId: '1',
      username: 'Elon Musk',
      content: '🚀 Excited about the future of AI and sustainable energy!',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 150000,
      retweets: 25000,
      likedBy: [],
      imageUrl: 'https://picsum.photos/500/300',
    ),
    Tweet(
      id: '2',
      userId: '2',
      username: 'Flutter Dev',
      content:
          'Just built an amazing app with Flutter! The hot reload feature is a game changer 🎮',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 5000,
      retweets: 1000,
      likedBy: [],
      imageUrl: 'https://picsum.photos/500/300',
    ),
    Tweet(
      id: '3',
      userId: '3',
      username: 'Tech News',
      content:
          'Breaking: New AI model achieves human-level performance in multiple benchmarks! 🤖',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 25000,
      retweets: 5000,
      likedBy: [],
      imageUrl: 'https://picsum.photos/500/300',
    ),
  ];

  static List<Tweet> getTweets() {
    return tweets;
  }

  static Tweet? getTweetById(String id) {
    try {
      return tweets.firstWhere((tweet) => tweet.id == id);
    } catch (e) {
      return null;
    }
  }

  static void toggleLike(String tweetId) {
    final index = tweets.indexWhere((tweet) => tweet.id == tweetId);
    if (index != -1) {
      final tweet = tweets[index];
      final newLikedBy = List<String>.from(tweet.likedBy);
      if (!tweet.likedBy.contains('current_user')) {
        newLikedBy.add('current_user');
      } else {
        newLikedBy.remove('current_user');
      }
      
      tweets[index] = tweet.copyWith(
        likedBy: newLikedBy,
        likes: tweet.likedBy.contains('current_user') ? tweet.likes - 1 : tweet.likes + 1,
      );
    }
  }

  static void toggleRetweet(String tweetId) {
    final index = tweets.indexWhere((tweet) => tweet.id == tweetId);
    if (index != -1) {
      final tweet = tweets[index];
      tweets[index] = tweet.copyWith(
        retweets: tweet.retweets + 1,
      );
    }
  }

  static void addTweet({
    required String content,
    required String username,
    String? imageUrl,
  }) {
    final newTweet = Tweet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId:
          'current_user', // In a real app, this would be the authenticated user's ID
      username: username,
      content: content,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );

    tweets.insert(0, newTweet);
  }
}
