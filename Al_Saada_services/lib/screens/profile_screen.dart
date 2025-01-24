import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section profil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+225 0123456789',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Menu options
            Card(
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.location_on,
                    title: 'Mes adresses',
                    onTap: () {},
                  ),
                  const Divider(),
                  ProfileMenuItem(
                    icon: Icons.payment,
                    title: 'Moyens de paiement',
                    onTap: () {},
                  ),
                  const Divider(),
                  ProfileMenuItem(
                    icon: Icons.settings,
                    title: 'Paramètres',
                    onTap: () {},
                  ),
                  const Divider(),
                  ProfileMenuItem(
                    icon: Icons.help,
                    title: 'Aide et support',
                    onTap: () {},
                  ),
                  const Divider(),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    color: Colors.red,
                    onTap: () {
                      // Logique de déconnexion
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}