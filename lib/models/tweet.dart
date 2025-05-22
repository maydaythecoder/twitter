import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime createdAt;
  final int likes;
  final int retweets;
  final List<String> likedBy;
  final String? imageUrl;

  Tweet({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.retweets = 0,
    this.likedBy = const [],
    this.imageUrl,
  });

  factory Tweet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tweet(
      id: doc.id,
      userId: data['userId'] as String,
      username: data['username'] as String,
      content: data['content'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: data['likes'] as int? ?? 0,
      retweets: data['retweets'] as int? ?? 0,
      likedBy: List<String>.from(data['likedBy'] as List? ?? []),
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'retweets': retweets,
      'likedBy': likedBy,
      'imageUrl': imageUrl,
    };
  }

  Tweet copyWith({
    String? id,
    String? userId,
    String? username,
    String? content,
    DateTime? createdAt,
    int? likes,
    int? retweets,
    List<String>? likedBy,
    String? imageUrl,
  }) {
    return Tweet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      retweets: retweets ?? this.retweets,
      likedBy: likedBy ?? this.likedBy,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
