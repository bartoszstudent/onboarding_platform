import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;

  const AppAvatar({super.key, this.imageUrl, this.name, this.radius = 20});

  String _initials(String? name) {
    if (name == null || name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
          radius: radius, backgroundImage: NetworkImage(imageUrl!));
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      child: Text(_initials(name),
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
    );
  }
}
