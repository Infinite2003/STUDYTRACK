import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  
  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}