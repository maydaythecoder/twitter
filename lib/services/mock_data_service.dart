import 'package:twitter/models/tweet.dart';

class MockDataService {
  static final List<Tweet> tweets = [
    Tweet(
      id: '1',
      userId: '1',
      username: 'Elon Musk',
      userHandle: 'elonmusk',
      content: '🚀 Excited about the future of AI and sustainable energy!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 150000,
      retweets: 25000,
      replies: 5000,
    ),
    Tweet(
      id: '2',
      userId: '2',
      username: 'Flutter Dev',
      userHandle: 'flutterdev',
      content:
          'Just built an amazing app with Flutter! The hot reload feature is a game changer 🎮',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 5000,
      retweets: 1000,
      replies: 200,
    ),
    Tweet(
      id: '3',
      userId: '3',
      username: 'Tech News',
      userHandle: 'technews',
      content:
          'Breaking: New AI model achieves human-level performance in multiple benchmarks! 🤖',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 25000,
      retweets: 5000,
      replies: 1000,
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
      tweets[index] = tweet.copyWith(
        isLiked: !tweet.isLiked,
        likes: tweet.isLiked ? tweet.likes - 1 : tweet.likes + 1,
      );
    }
  }

  static void toggleRetweet(String tweetId) {
    final index = tweets.indexWhere((tweet) => tweet.id == tweetId);
    if (index != -1) {
      final tweet = tweets[index];
      tweets[index] = tweet.copyWith(
        isRetweeted: !tweet.isRetweeted,
        retweets: tweet.isRetweeted ? tweet.retweets - 1 : tweet.retweets + 1,
      );
    }
  }

  static void addTweet({
    required String content,
    required String username,
    required String userHandle,
    String? imageUrl,
  }) {
    final newTweet = Tweet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId:
          'current_user', // In a real app, this would be the authenticated user's ID
      username: username,
      userHandle: userHandle,
      content: content,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
    );

    tweets.insert(0, newTweet);
  }
}
