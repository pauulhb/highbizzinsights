import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/domain_models.dart';
import '../services/app_state.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 32,
            child: Text(user != null && user.name.isNotEmpty ? user.name[0] : '?',
                style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 12),
          Center(
              child: Text(user?.name ?? '', style: Theme.of(context).textTheme.titleLarge)),
          Center(
              child: Text(
                  user != null ? userRoleLabel(user.role) : '',
                  style: Theme.of(context).textTheme.bodyMedium)),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(user?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Region / State'),
            subtitle: Text('${user?.region ?? ''} / ${user?.state ?? ''}'),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<AppState>().logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
