import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tweet.dart';
import 'firebase_service.dart';

class TweetService {
  final FirebaseService _firebaseService = FirebaseService();
  final CollectionReference _tweetsCollection =
      FirebaseFirestore.instance.collection('tweets');

  // Get tweets stream
  Stream<List<Tweet>> getTweetsStream() {
    return _tweetsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Tweet.fromFirestore(doc)).toList();
    });
  }

  // Create a new tweet
  Future<Tweet> createTweet({
    required String content,
    String? imageUrl,
  }) async {
    final user = _firebaseService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Get user data from Firestore
    final userDoc = await _firebaseService.firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final userData = userDoc.data() as Map<String, dynamic>;

    final tweet = Tweet(
      id: '', // Will be set by Firestore
      userId: user.uid,
      username: userData['username'] as String,
      content: content,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );

    final docRef = await _tweetsCollection.add(tweet.toMap());
    return tweet.copyWith(id: docRef.id);
  }

  // Like a tweet
  Future<void> toggleLike(String tweetId) async {
    final user = _firebaseService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tweetRef = _tweetsCollection.doc(tweetId);
    final tweetDoc = await tweetRef.get();
    final tweet = Tweet.fromFirestore(tweetDoc);

    final likedBy = List<String>.from(tweet.likedBy);
    if (likedBy.contains(user.uid)) {
      likedBy.remove(user.uid);
    } else {
      likedBy.add(user.uid);
    }

    await tweetRef.update({
      'likedBy': likedBy,
      'likes': likedBy.length,
    });
  }

  // Retweet
  Future<void> retweet(String tweetId) async {
    final tweetRef = _tweetsCollection.doc(tweetId);
    await tweetRef.update({
      'retweets': FieldValue.increment(1),
    });
  }

  // Delete tweet
  Future<void> deleteTweet(String tweetId) async {
    final user = _firebaseService.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final tweetDoc = await _tweetsCollection.doc(tweetId).get();
    final tweet = Tweet.fromFirestore(tweetDoc);

    if (tweet.userId != user.uid) {
      throw Exception('Not authorized to delete this tweet');
    }

    await _tweetsCollection.doc(tweetId).delete();
  }

  // Add mock tweets
  Future<void> addMockTweets() async {
    final mockTweets = [
      {
        'userId': 'mock_user_1',
        'username': 'John Doe',
        'content':
            'Just launched my new Flutter app! 🚀 #FlutterDev #MobileDev',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 2))),
        'likes': 42,
        'retweets': 12,
        'likedBy': [],
        'imageUrl': 'https://picsum.photos/500/300',
      },
      {
        'userId': 'mock_user_2',
        'username': 'Jane Smith',
        'content':
            'Beautiful day for coding! ☀️ Working on some exciting features for my Twitter clone.',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 5))),
        'likes': 28,
        'retweets': 5,
        'likedBy': [],
      },
      {
        'userId': 'mock_user_3',
        'username': 'Tech Enthusiast',
        'content':
            'Firebase + Flutter = ❤️ The perfect combination for rapid app development!',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 8))),
        'likes': 56,
        'retweets': 23,
        'likedBy': [],
      },
    ];

    // Check if tweets already exist
    final existingTweets = await _tweetsCollection.get();
    if (existingTweets.docs.isEmpty) {
      // Add mock tweets
      for (final tweet in mockTweets) {
        await _tweetsCollection.add(tweet);
      }
    }
  }
}
