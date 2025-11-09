import 'package:flutter/material.dart';
import '../components/user_avatar.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Panel główny",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Row(
            children: const [
              Icon(Icons.notifications_none),
              SizedBox(width: 16),
              UserAvatar(),
            ],
          ),
        ],
      ),
    );
  }
}
