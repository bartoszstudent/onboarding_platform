import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../components/user_avatar.dart';
import '../../core/constants/design_tokens.dart';
import '../../data/services/auth_service.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Page title / breadcrumb
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/menu.svg',
                    width: 20,
                    height: 20,
                    color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 12),
                const Text('Panel główny',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Search
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                isDense: true,
                hintText: 'Szukaj kursów, użytkowników...',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icons/search.svg',
                      width: 16, height: 16, color: Colors.black54),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Actions
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/bell.svg',
                  width: 20, height: 20, color: Colors.black54)),
          const SizedBox(width: 8),
          const UserAvatar(),
          const SizedBox(width: 8),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('Profil')),
              const PopupMenuItem(value: 2, child: Text('Wyloguj')),
            ],
            onSelected: (v) async {
              if (v == 2) {
                await AuthService.logout();
                if (!context.mounted) return;
                GoRouter.of(context).go('/');
              }
            },
          ),
        ],
      ),
    );
  }
}
