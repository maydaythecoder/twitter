import 'package:flutter/material.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/services/mock_data_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends StatefulWidget {
  final Tweet tweet;
  final VoidCallback? onTap;

  const TweetCard({
    super.key,
    required this.tweet,
    this.onTap,
  });

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  late Tweet _tweet;

  @override
  void initState() {
    super.initState();
    _tweet = widget.tweet;
  }

  void _toggleLike() {
    setState(() {
      MockDataService.toggleLike(_tweet.id);
      _tweet = MockDataService.getTweetById(_tweet.id)!;
    });
  }

  void _toggleRetweet() {
    setState(() {
      MockDataService.toggleRetweet(_tweet.id);
      _tweet = MockDataService.getTweetById(_tweet.id)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      _tweet.username[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _tweet.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '@${_tweet.username}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· ${timeago.format(_tweet.createdAt)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _tweet.content,
                style: const TextStyle(height: 1.3),
              ),
              if (_tweet.imageUrl != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      _tweet.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: const Center(
                            child: Icon(Icons.error_outline),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TweetActionButton(
                    icon: Icons.chat_bubble_outline,
                    isActive: false,
                    onTap: () {},
                    inactiveColor: Colors.grey,
                  ),
                  _TweetActionButton(
                    icon: Icons.repeat,
                    count: _tweet.retweets,
                    onTap: _toggleRetweet,
                    activeColor: Colors.green,
                    isActive: _tweet.retweets > 0,
                    inactiveColor: Colors.grey[700],
                  ),
                  _TweetActionButton(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    count: _tweet.likes,
                    isActive: _tweet.likedBy.contains('current_user'),
                    activeColor: Colors.red,
                    onTap: _toggleLike,
                    inactiveColor: Colors.grey[700],
                  ),
                  _TweetActionButton(
                    icon: Icons.share_outlined,
                    isActive: false,
                    onTap: () {},
                    inactiveColor: Colors.grey[700],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TweetActionButton extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final int? count;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;
  final VoidCallback onTap;

  const _TweetActionButton({
    required this.icon,
    this.activeIcon,
    this.count,
    required this.isActive,
    this.activeColor,
    this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive
        ? (activeColor ?? Theme.of(context).colorScheme.primary)
        : (inactiveColor ?? Colors.grey[700]!);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? (activeIcon ?? icon) : icon,
              size: 18,
              color: iconColor,
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count!),
                style: TextStyle(
                  color: iconColor,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
