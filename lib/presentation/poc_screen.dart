import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/task_provider.dart';

class PocScreen extends StatelessWidget {
  const PocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PoC STUDYTRACK"),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "PoC Offline First",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: provider.isLoading
                ? null
                : () {
                    provider.createTask();
                  },
            child: const Text("Guardar Tarea"),
          ),

          const SizedBox(height: 20),

          Text(
            provider.statusMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    ),
    );
  }
}