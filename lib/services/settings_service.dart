import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  // Profile data
  String _name = 'Current User';
  final String _handle = '@currentuser';
  String _bio =
      'Flutter developer | Coffee enthusiast | Building Twitter clone';
  String _location = 'San Francisco, CA';
  String _website = 'example.com';
  int _followingCount = 1234;
  int _followersCount = 5678;

  // Settings
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _privateAccount = false;

  // Getters
  String get name => _name;
  String get handle => _handle;
  String get bio => _bio;
  String get location => _location;
  String get website => _website;
  int get followingCount => _followingCount;
  int get followersCount => _followersCount;
  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get privateAccount => _privateAccount;

  // Profile update methods
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? location,
    String? website,
  }) async {
    if (name != null) _name = name;
    if (bio != null) _bio = bio;
    if (location != null) _location = location;
    if (website != null) _website = website;
    notifyListeners();
  }

  // Settings update methods
  Future<void> updateSettings({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? privateAccount,
  }) async {
    if (darkMode != null) {
      _darkMode = darkMode;
    }
    if (notificationsEnabled != null) {
      _notificationsEnabled = notificationsEnabled;
    }
    if (privateAccount != null) {
      _privateAccount = privateAccount;
    }
    notifyListeners();
  }

  // Following/Followers management
  Future<void> toggleFollow(String userId, bool isFollowing) async {
    if (isFollowing) {
      _followingCount--;
    } else {
      _followingCount++;
    }
    notifyListeners();
  }

  Future<void> handleFollowRequest(String userId, bool accept) async {
    if (accept) {
      _followersCount++;
    }
    notifyListeners();
  }
}
