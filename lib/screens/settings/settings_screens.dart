import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/services/settings_service.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Username'),
            subtitle: Text(context.watch<SettingsService>().handle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show username change dialog
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark mode'),
            value: context.watch<SettingsService>().darkMode,
            onChanged: (value) {
              context.read<SettingsService>().updateSettings(darkMode: value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Delete account'),
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement account deletion
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push notifications'),
            subtitle: const Text('Receive notifications on your device'),
            value: context.watch<SettingsService>().notificationsEnabled,
            onChanged: (value) {
              context.read<SettingsService>().updateSettings(
                    notificationsEnabled: value,
                  );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Email notifications'),
            subtitle: Text('Manage your email notification preferences'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const ListTile(
            title: Text('Muted accounts'),
            subtitle: Text('Manage accounts you\'ve muted'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and safety'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Private account'),
            subtitle: const Text('Only approved followers can see your tweets'),
            value: context.watch<SettingsService>().privateAccount,
            onChanged: (value) {
              context.read<SettingsService>().updateSettings(
                    privateAccount: value,
                  );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Blocked accounts'),
            subtitle: Text('Manage accounts you\'ve blocked'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const ListTile(
            title: Text('Content preferences'),
            subtitle: Text('Manage your content preferences'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Getting started'),
            subtitle: Text('Learn the basics of using Twitter'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Safety and security'),
            subtitle: Text('Tips for keeping your account secure'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy'),
            subtitle: Text('Learn about your privacy options'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('Contact support'),
            subtitle: Text('Get help from our support team'),
          ),
        ],
      ),
    );
  }
}
