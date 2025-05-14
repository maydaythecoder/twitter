
class Tweet {
  final String id;
  final String userId;
  final String username;
  final String userHandle;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int retweets;
  final int replies;
  final String? imageUrl;
  final bool isLiked;
  final bool isRetweeted;

  Tweet({
    required this.id,
    required this.userId,
    required this.username,
    required this.userHandle,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.retweets = 0,
    this.replies = 0,
    this.imageUrl,
    this.isLiked = false,
    this.isRetweeted = false,
  });

  Tweet copyWith({
    String? id,
    String? userId,
    String? username,
    String? userHandle,
    String? content,
    DateTime? timestamp,
    int? likes,
    int? retweets,
    int? replies,
    String? imageUrl,
    bool? isLiked,
    bool? isRetweeted,
  }) {
    return Tweet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userHandle: userHandle ?? this.userHandle,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      retweets: retweets ?? this.retweets,
      replies: replies ?? this.replies,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
      isRetweeted: isRetweeted ?? this.isRetweeted,
    );
  }
}
