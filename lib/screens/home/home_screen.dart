import 'package:flutter/material.dart';
import 'package:twitter/screens/compose/compose_tweet_screen.dart';
import 'package:twitter/services/mock_data_service.dart';
import 'package:twitter/widgets/tweet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _openComposeTweet() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ComposeTweetScreen(),
      ),
    );
    // Refresh the state when returning from compose screen
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // In a real app, this would fetch new tweets
          setState(() {});
        },
        child: ListView.builder(
          itemCount: MockDataService.tweets.length,
          itemBuilder: (context, index) {
            final tweet = MockDataService.tweets[index];
            return TweetCard(
              tweet: tweet,
              onTap: () {
                // In a real app, this would navigate to tweet detail
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openComposeTweet,
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            selectedIcon: Icon(Icons.mail),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
