import 'package:flutter/material.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/services/mock_data_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final VoidCallback? onTap;

  const TweetCard({super.key, required this.tweet, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      tweet.username[0].toUpperCase(),
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
                            Text(
                              tweet.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '@${tweet.userHandle}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· ${timeago.format(tweet.timestamp)}',
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
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(tweet.content),
              if (tweet.imageUrl != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    tweet.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TweetActionButton(
                    icon: Icons.chat_bubble_outline,
                    count: tweet.replies,
                    onTap: () {},
                  ),
                  _TweetActionButton(
                    icon: Icons.repeat,
                    count: tweet.retweets,
                    isActive: tweet.isRetweeted,
                    onTap: () => MockDataService.toggleRetweet(tweet.id),
                  ),
                  _TweetActionButton(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    count: tweet.likes,
                    isActive: tweet.isLiked,
                    activeColor: Colors.red,
                    onTap: () => MockDataService.toggleLike(tweet.id),
                  ),
                  _TweetActionButton(icon: Icons.share_outlined, onTap: () {}),
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
  final VoidCallback onTap;

  const _TweetActionButton({
    required this.icon,
    this.activeIcon,
    this.count,
    this.isActive = false,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(
              isActive ? (activeIcon ?? icon) : icon,
              size: 18,
              color:
                  isActive
                      ? (activeColor ?? Theme.of(context).colorScheme.primary)
                      : null,
            ),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color:
                      isActive
                          ? (activeColor ??
                              Theme.of(context).colorScheme.primary)
                          : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
