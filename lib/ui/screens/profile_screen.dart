import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Calendario',
            onPressed: () => Navigator.pushNamed(context, '/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            tooltip: 'Tareas',
            onPressed: () => Navigator.pushNamed(context, '/tasks'),
          ),
          // Menú overflow para los íconos restantes — evita overflow horizontal
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') Navigator.pushNamed(context, '/about');
              if (value == 'help') Navigator.pushNamed(context, '/help');
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info, size: 20),
                    SizedBox(width: 8),
                    Text('Acerca de'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help, size: 20),
                    SizedBox(width: 8),
                    Text('Ayuda'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  32,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estudiante',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'estudiante@universidad.cl',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis, // evita overflow de texto largo
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ajustes',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}