import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.pushNamed(context, '/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () => Navigator.pushNamed(context, '/tasks'),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => Navigator.pushNamed(context, '/help'),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Estudiante',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'estudiante@universidad.cl',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'Ajustes',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}