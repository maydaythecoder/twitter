import 'package:flutter/material.dart';
import 'package:twitter/screens/compose/compose_tweet_screen.dart';
import 'package:twitter/screens/search/search_screen.dart';
import 'package:twitter/screens/notifications/notifications_screen.dart';
import 'package:twitter/screens/messages/messages_screen.dart';
import 'package:twitter/screens/profile/profile_screen.dart';
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
  final List<Widget> _screens = [
    const _HomeTab(),
    const SearchScreen(),
    const NotificationsScreen(),
    const MessagesScreen(),
  ];

  void _openComposeTweet() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ComposeTweetScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _openComposeTweet,
              child: const Icon(Icons.edit),
            )
          : null,
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

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => _openProfile(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Text(
                'CU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
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
    );
  }
}
