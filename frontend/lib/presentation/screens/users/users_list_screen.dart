import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../data/services/api_client.dart';

import '../../ui/app_card.dart';
import '../../ui/avatar.dart';
import '../../ui/badge.dart' as ui_badge;

import 'widgets/add_user_screen.dart';
import 'widgets/edit_user_screen.dart';
import 'widgets/assign_courses_screen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  String _search = '';
  String _roleFilter = '';

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
  final response = await ApiClient.get('api/companies/me/users/');

  if (response.statusCode != 200) {
    throw Exception('Błąd pobierania użytkowników');
  }

  final List data = jsonDecode(response.body);
  return data.cast<Map<String, dynamic>>();
}

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

  Map<String, Color> _roleColors(String role) {
    switch (role) {
      case 'super-admin':
        return {'bg': Tokens.purple100, 'text': Tokens.purple700};
      case 'admin':
        return {'bg': Tokens.blue100, 'text': Tokens.blue700};
      case 'hr':
        return {'bg': Tokens.green100, 'text': Tokens.green700};
      default:
        return {'bg': Tokens.gray100, 'text': Tokens.gray700};
    }
  }

  String _nameFromEmail(String email) {
    final namePart = email.split('@').first.replaceAll('.', ' ');
    return namePart
        .split(' ')
        .map((e) =>
            e.isNotEmpty ? '${e[0].toUpperCase()}${e.substring(1)}' : '')
        .join(' ');
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final users = snapshot.data!;
        final filtered = users.where((u) {
          final email = (u['email'] ?? '').toString().toLowerCase();
          final name = _nameFromEmail(email).toLowerCase();

          final matchesSearch =
              _search.isEmpty || email.contains(_search) || name.contains(_search);

          final matchesRole =
              _roleFilter.isEmpty || u['role'] == _roleFilter;

          return matchesSearch && matchesRole;
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zarządzanie użytkownikami',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Dodawaj i zarządzaj użytkownikami platformy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => const AddUserScreen(),
                      );
                      setState(() => _usersFuture = _fetchUsers());
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/plus.svg',
                      width: 18,
                      height: 18,
                      color: Colors.white,
                    ),
                    label: const Text('Dodaj użytkownika'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              AppCard(
                padding: const EdgeInsets.all(Tokens.spacing),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v.toLowerCase()),
                        decoration: InputDecoration(
                          hintText: 'Szukaj użytkowników...',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              'assets/icons/search.svg',
                              width: 16,
                              height: 16,
                              color: Colors.black54,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
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
                      onChanged: (v) =>
                          setState(() => _roleFilter = v ?? ''),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      color: Tokens.gray50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                      final email = u['email'];
                      final role = u['role'];
                      final courses = u['courses_count'] ?? 0;
                      final colors = _roleColors(role);

                      return _HoverRow(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Tokens.gray200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    AppAvatar(
                                      name: _nameFromEmail(email),
                                      radius: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(_nameFromEmail(email)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(email),
                              ),
                              Expanded(
                                child: ui_badge.Badge(
                                  text: _roleLabel(role),
                                  color: colors['bg']!,
                                  textColor: colors['text']!,
                                ),
                              ),
                              Expanded(
                                child: Text('$courses kursów'),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              EditUserScreen(user: u),
                                        );
                                      },
                                      child: const Text('Edytuj'),
                                    ),
                                    const SizedBox(width: 6),
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              AssignCoursesScreen(user: u),
                                        );
                                      },
                                      child: const Text('Przypisz kursy'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HoverRow extends StatefulWidget {
  final Widget child;
  const _HoverRow({required this.child});

  @override
  State<_HoverRow> createState() => _HoverRowState();
}

class _HoverRowState extends State<_HoverRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        color: _hover ? Tokens.gray50 : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}
