import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/design_tokens.dart';
import '../../data/services/auth_service.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool get _isCollapsed => MediaQuery.of(context).size.width < 900;

  String? _role;

  List<_MenuItem> get _items {
    final base = [
      const _MenuItem(
          path: '/dashboard',
          asset: 'assets/icons/home.svg',
          label: 'Dashboard'),
      const _MenuItem(
          path: '/courses',
          asset: 'assets/icons/book-open.svg',
          label: 'Kursy'),
    ];

    // hide users/settings for super_admins (they manage companies elsewhere)
    if (_role != 'super_admin') {
      base.add(const _MenuItem(
          path: '/users',
          asset: 'assets/icons/users.svg',
          label: 'Użytkownicy'));
      base.add(const _MenuItem(
          path: '/settings',
          asset: 'assets/icons/settings.svg',
          label: 'Ustawienia'));
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    // ensure we have the role loaded
    if (_role == null) {
      AuthService.getRole().then((r) {
        if (!mounted) return;
        setState(() {
          _role = r ?? 'employee';
        });
      });
    }

    final location = GoRouterState.of(context).uri.path;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isCollapsed ? 72 : 240,
      decoration: BoxDecoration(
        color: Tokens.primary,
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 8),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildBrand(context),
            const SizedBox(height: 18),
            Expanded(child: _buildMenu(context, location)),
            _buildAccount(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 8 : 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/icons/book-open.svg',
                  color: Colors.white),
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: 12),
            const Text('Onboardly',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context, String location) {
    return ListView(
      padding:
          EdgeInsets.symmetric(vertical: 8, horizontal: _isCollapsed ? 4 : 8),
      children: _items.map((item) {
        final bool active = location.startsWith(item.path);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Material(
            color: active ? Colors.white.withAlpha(15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => GoRouter.of(context).go(item.path),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: _isCollapsed ? 8 : 12),
                child: Row(
                  children: [
                    SvgPicture.asset(item.asset,
                        color: active
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white70),
                    if (!_isCollapsed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(item.label,
                              style: TextStyle(
                                  color: active ? Colors.white : Colors.white70,
                                  fontWeight: active
                                      ? FontWeight.w600
                                      : FontWeight.normal))),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAccount(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: _isCollapsed ? 8 : 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SvgPicture.asset('assets/icons/users.svg',
                    color: Colors.black54),
              )),
          if (!_isCollapsed) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jan Kowalski',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('Admin',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/menu.svg',
                    color: Colors.white70, width: 20, height: 20)),
          ]
        ],
      ),
    );
  }
}

class _MenuItem {
  final String path;
  final String asset;
  final String label;
  const _MenuItem(
      {required this.path, required this.asset, required this.label});
}
