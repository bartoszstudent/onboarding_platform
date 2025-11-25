import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../ui/app_card.dart';
import '../../../core/constants/design_tokens.dart';
import '../../ui/avatar.dart';
import '../../ui/badge.dart' as ui_badge;
import 'widgets/add_user_screen.dart';
import 'widgets/edit_user_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String _search = '';
  String _roleFilter = '';
  bool _showAdd = false;

  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Jan Kowalski',
      'email': 'jan.kowalski@firma.pl',
      'role': 'employee',
      'courses': 3
    },
    {
      'id': '2',
      'name': 'Anna Nowak',
      'email': 'anna.nowak@firma.pl',
      'role': 'employee',
      'courses': 5
    },
    {
      'id': '3',
      'name': 'Piotr Wiśniewski',
      'email': 'piotr.wisniewski@firma.pl',
      'role': 'hr',
      'courses': 8
    },
    {
      'id': '4',
      'name': 'Maria Lewandowska',
      'email': 'maria.lewandowska@firma.pl',
      'role': 'admin',
      'courses': 12
    },
    {
      'id': '5',
      'name': 'Tomasz Dąbrowski',
      'email': 'tomasz.dabrowski@firma.pl',
      'role': 'employee',
      'courses': 2
    },
  ];

  String _roleLabel(String role) {
    switch (role) {
      case 'super-admin':
        return 'Super Admin';
      case 'admin':
        return 'Administrator';
      case 'hr':
        return 'HR';
      default:
        return 'Pracownik';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) {
      final matchesSearch = _search.isEmpty ||
          u['name'].toLowerCase().contains(_search.toLowerCase()) ||
          u['email'].toLowerCase().contains(_search.toLowerCase());
      final matchesRole = _roleFilter.isEmpty || u['role'] == _roleFilter;
      return matchesSearch && matchesRole;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zarządzanie użytkownikami',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text('Dodawaj i zarządzaj użytkownikami platformy',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => const AddUserScreen(),
                  );
                },
                icon: SvgPicture.asset('assets/icons/plus.svg',
                    width: 18, height: 18, color: Colors.white),
                label: const Text('Dodaj użytkownika'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Tokens.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Tokens.radius)),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search and filters
          AppCard(
            padding: const EdgeInsets.all(Tokens.spacing),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Szukaj użytkowników...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset('assets/icons/search.svg',
                            width: 16, height: 16, color: Colors.black54),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _roleFilter.isEmpty ? null : _roleFilter,
                  hint: const Text('Wszystkie role'),
                  items: const [
                    DropdownMenuItem(
                        value: 'admin', child: Text('Administrator')),
                    DropdownMenuItem(value: 'hr', child: Text('HR')),
                    DropdownMenuItem(
                        value: 'employee', child: Text('Pracownik')),
                  ],
                  onChanged: (v) => setState(() => _roleFilter = v ?? ''),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Table
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  color: Tokens.gray50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Row(
                    children: [
                      Expanded(flex: 2, child: Text('Użytkownik')),
                      Expanded(flex: 2, child: Text('Email')),
                      Expanded(child: Text('Rola')),
                      Expanded(child: Text('Przypisane kursy')),
                      Expanded(child: Text('Akcje')),
                    ],
                  ),
                ),
                ...filtered.map((u) {
                  return _HoverableListItem(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Tokens.gray200))),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                AppAvatar(name: u['name'], radius: 20),
                                const SizedBox(width: 12),
                                Text(u['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Tokens.textDark)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: SvgPicture.asset(
                                        'assets/icons/mail.svg',
                                        color: const Color(0xFF94A3B8))),
                                const SizedBox(width: 8),
                                Text(u['email'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Tokens.textMuted2)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Builder(builder: (ctx) {
                              final role = u['role'] as String;
                              Color bg = Tokens.gray100;
                              Color txt = Tokens.gray700;
                              switch (role) {
                                case 'super-admin':
                                  bg = Tokens.purple100;
                                  txt = Tokens.purple700;
                                  break;
                                case 'admin':
                                  bg = Tokens.blue100;
                                  txt = Tokens.blue700;
                                  break;
                                case 'hr':
                                  bg = Tokens.green100;
                                  txt = Tokens.green700;
                                  break;
                                default:
                                  bg = Tokens.gray100;
                                  txt = Tokens.gray700;
                              }
                              return ui_badge.Badge(
                                text: _roleLabel(role),
                                color: bg,
                                textColor: txt,
                                leading: SvgPicture.asset(
                                    'assets/icons/shield.svg',
                                    width: 12,
                                    height: 12,
                                    color: txt),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                              );
                            }),
                          ),
                          Expanded(
                              child: Text('${u['courses']} kursów',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Tokens.textDark))),
                          Expanded(
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => EditUserScreen(user: u), 
                                    );
                                  },
                                  child: const Text('Edytuj'),
                                ),
                                const SizedBox(width: 6),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text('Przypisz kursy')),
                                IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                        'assets/icons/more-vertical.svg',
                                        width: 20,
                                        height: 20)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableListItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _HoverableListItem({required this.child, this.onTap});

  @override
  State<_HoverableListItem> createState() => _HoverableListItemState();
}

class _HoverableListItemState extends State<_HoverableListItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        color: _hover ? Tokens.gray50 : Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
