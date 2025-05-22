import 'package:flutter/material.dart';
import 'package:twitter/services/mock_data_service.dart';
import 'package:twitter/widgets/tweet_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  List<dynamic> _getSearchResults() {
    if (_searchQuery.isEmpty) return [];

    final tweets = MockDataService.tweets.where((tweet) {
      final content = tweet.content.toLowerCase();
      final username = tweet.username.toLowerCase();
      final handle = tweet.username.toLowerCase();
      final query = _searchQuery.toLowerCase();

      return content.contains(query) ||
          username.contains(query) ||
          handle.contains(query);
    }).toList();

    // In a real app, we would also search users here
    return tweets;
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _getSearchResults();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Twitter',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tweets'),
            Tab(text: 'People'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tweets Tab
          _searchQuery.isEmpty
              ? const Center(
                  child: Text(
                    'Search for tweets',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : searchResults.isEmpty
                  ? const Center(
                      child: Text(
                        'No tweets found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return TweetCard(
                          tweet: searchResults[index],
                          onTap: () {
                            // In a real app, navigate to tweet detail
                          },
                        );
                      },
                    ),
          // People Tab
          const Center(
            child: Text(
              'User search coming soon',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
