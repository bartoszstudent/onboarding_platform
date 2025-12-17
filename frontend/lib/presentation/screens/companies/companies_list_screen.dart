import 'package:flutter/material.dart';
import '../../ui/app_card.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/services/company_service.dart';
import '../../../data/models/company_model.dart';
import 'widgets/add_company_screen.dart';
import 'widgets/manage_company_screen.dart';

class _HoverableListItem extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _HoverableListItem({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }
}

class CompanyManagementScreen extends StatefulWidget {
  const CompanyManagementScreen({super.key});

  @override
  State<CompanyManagementScreen> createState() => _CompanyManagementScreenState();
}

class _CompanyManagementScreenState extends State<CompanyManagementScreen> {
  String _search = '';
  String _statusFilter = '';
  bool _showAdd = false;
  bool _showEdit = false;
  bool _showManage = false;
  bool _isLoading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _selectedCompany;
  List<Company> _apiCompanies = [];

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final companies = await CompanyService.listCompanies();
      setState(() {
        _apiCompanies = companies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd pobierania firm: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  final List<Map<String, dynamic>> _companies = [
    {
      'id': '1',
      'name': 'TechCorp Sp. z o.o.',
      'domain': 'techcorp',
      'subdomain': 'techcorp.onboardly.app',
      'employees': 45,
      'courses': 12,
      'logo': '',
      'admins': [
        {'id': '1', 'name': 'Jan Kowalski', 'email': 'admin@techcorp.pl', 'role': 'admin'},
        {'id': '2', 'name': 'Anna Nowak', 'email': 'anna@techcorp.pl', 'role': 'hr'},
      ],
      'status': 'active',
      'maxUsers': 100,
      'maxCourses': 50,
      'createdAt': '2024-01-15',
    },
    {
      'id': '2',
      'name': 'Digital Solutions',
      'domain': 'digitalsolutions',
      'subdomain': 'digitalsolutions.onboardly.app',
      'employees': 78,
      'courses': 18,
      'logo': '',
      'admins': [
        {'id': '3', 'name': 'Piotr Wiśniewski', 'email': 'hr@digitalsolutions.com', 'role': 'admin'},
      ],
      'status': 'active',
      'maxUsers': 150,
      'maxCourses': 75,
      'createdAt': '2024-02-20',
    },
    {
      'id': '3',
      'name': 'StartupHub',
      'domain': 'startuphub',
      'subdomain': 'startuphub.onboardly.app',
      'employees': 23,
      'courses': 8,
      'logo': '',
      'admins': [
        {'id': '4', 'name': 'Maria Lewandowska', 'email': 'admin@startuphub.io', 'role': 'admin'},
      ],
      'status': 'active',
      'maxUsers': 50,
      'maxCourses': 30,
      'createdAt': '2024-03-10',
    },
    {
      'id': '4',
      'name': 'Enterprise Inc.',
      'domain': 'enterprise',
      'subdomain': 'enterprise.onboardly.app',
      'employees': 156,
      'courses': 24,
      'logo': '',
      'admins': [
        {'id': '5', 'name': 'Tomasz Dąbrowski', 'email': 'contact@enterprise.com', 'role': 'admin'},
        {'id': '6', 'name': 'Ewa Kowalczyk', 'email': 'ewa@enterprise.com', 'role': 'hr'},
        {'id': '7', 'name': 'Michał Nowicki', 'email': 'michal@enterprise.com', 'role': 'hr'},
      ],
      'status': 'inactive',
      'maxUsers': 200,
      'maxCourses': 100,
      'createdAt': '2023-12-05',
    },
  ];

  String _statusLabel(String status) {
    return status == 'active' ? 'Aktywna' : 'Nieaktywna';
  }

  @override
  Widget build(BuildContext context) {
    // Mapowanie firm z API na format wyświetlania
    final List<Map<String, dynamic>> displayCompanies = _apiCompanies.map((c) {
      return {
        'id': c.id.toString(),
        'name': c.name,
        'domain': c.domain,
        'subdomain': '${c.domain}.onboardly.app',
        'employees': 0,
        'courses': 0,
        'logo': c.logoUrl ?? '',
        'admins': [],
        'status': 'active',
        'maxUsers': 100,
        'maxCourses': 50,
        'createdAt': c.createdAt?.toString().split(' ')[0] ?? '2025-01-01',
      };
    }).toList();

    // Jeśli nie ma firm z API, użyj przykładowych
    final companiesData = displayCompanies.isEmpty ? _companies : displayCompanies;

    final filtered = companiesData.where((c) {
      final matchesSearch = _search.isEmpty ||
          c['name'].toLowerCase().contains(_search.toLowerCase()) ||
          c['subdomain'].toLowerCase().contains(_search.toLowerCase());

      final matchesStatus = _statusFilter.isEmpty || c['status'] == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();

    return Stack(
      children: [
        // ---- GŁÓWNY UI ----
        SingleChildScrollView(
          padding: const EdgeInsets.all(Tokens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zarządzanie firmami',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Tokens.spacingSm),
                      Text(
                        'Panel Super Admina - zarządzaj wszystkimi firmami',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _showAdd = true),
                    icon: Icon(Icons.add, color: Colors.white),
                    label: const Text('Dodaj firmę'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Tokens.spacingLg),

              // Search + Filters
              AppCard(
                padding: const EdgeInsets.all(Tokens.spacing),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        decoration: InputDecoration(
                          hintText: 'Szukaj firm...',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Tokens.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Tokens.radius),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Tokens.spacingLg),
                    DropdownButton<String>(
                      value: _statusFilter.isEmpty ? null : _statusFilter,
                      hint: const Text('Wszystkie statusy'),
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Aktywne')),
                        DropdownMenuItem(value: 'inactive', child: Text('Nieaktywne')),
                      ],
                      onChanged: (v) => setState(() => _statusFilter = v ?? ''),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Tokens.spacingLg),

              // Table
              AppCard(
                padding: EdgeInsets.zero,
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                  children: [
                    Container(
                      color: Tokens.gray50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Tokens.spacing, vertical: Tokens.spacingSm),
                      child: const Row(
                        children: [
                          Expanded(flex: 2, child: Text('Firma')),
                          Expanded(child: Text('Subdomena')),
                          Expanded(child: Text('Administratorzy')),
                          Expanded(child: Text('Użytkownicy')),
                          Expanded(child: Text('Kursy')),
                          Expanded(child: Text('Status')),
                          Expanded(child: Text('Akcje')),
                        ],
                      ),
                    ),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          'Brak firm do wyświetlenia',
                          style: TextStyle(color: Tokens.textMuted2),
                        ),
                      ),
                    ...filtered.map((c) {
                      return _HoverableListItem(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Tokens.spacing, vertical: Tokens.spacingSm),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Tokens.gray200)),
                          ),
                          child: Row(
                            children: [
                              // Firma
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Tokens.blue,
                                      child: Icon(Icons.business, color: Tokens.background),
                                    ),
                                    const SizedBox(width: Tokens.spacingSm),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c['name'], style: Theme.of(context).textTheme.bodyLarge),
                                        Text('Od ${c['createdAt']}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Tokens.textMuted2)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Subdomain
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(Icons.public, size: 18, color: Tokens.textMuted2),
                                    const SizedBox(width: Tokens.spacingXs),
                                    Text(c['subdomain'], style: TextStyle(color: Tokens.textMuted2)),
                                  ],
                                ),
                              ),

                              // Administratorzy
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...c['admins'].take(2).map<Widget>((a) {
                                      return Row(
                                        children: [
                                          Icon(Icons.shield, size: 14, color: Tokens.textMuted2),
                                          const SizedBox(width: Tokens.spacingXs),
                                          Text(a['name'],
                                              style: TextStyle(color: Tokens.textMuted2, fontSize: 12)),
                                        ],
                                      );
                                    }),
                                    if (c['admins'].length > 2)
                                      Text(
                                        '+${c['admins'].length - 2} więcej',
                                        style: TextStyle(color: Tokens.blue, fontSize: 12),
                                      )
                                  ],
                                ),
                              ),

                              // Użytkownicy
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${c['employees']} / ${c['maxUsers']}',
                                        style: Theme.of(context).textTheme.bodyLarge),
                                    const SizedBox(height: Tokens.spacingXs),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(Tokens.radius),
                                      child: LinearProgressIndicator(
                                        value: c['employees'] / c['maxUsers'],
                                        backgroundColor: Tokens.gray100,
                                        color: Tokens.blue,
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Kursy
                              Expanded(
                                child: Text('${c['courses']} / ${c['maxCourses']}',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ),

                              // Status
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Tokens.spacingSm, vertical: Tokens.spacingXs),
                                  decoration: BoxDecoration(
                                    color: c['status'] == 'active'
                                        ? Tokens.green100
                                        : Tokens.gray100,
                                    borderRadius: BorderRadius.circular(Tokens.radius),
                                  ),
                                  child: Text(
                                    _statusLabel(c['status']),
                                    style: TextStyle(
                                      color: c['status'] == 'active' ? Tokens.green700 : Tokens.gray700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              // Akcje
                              Expanded(
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCompany = c;
                                          _showManage = true;
                                        });
                                      },
                                      child: const Text('Zarządzaj'),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCompany = c;
                                          _showEdit = true;
                                        });
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.delete, color: Tokens.destructive),
                                    ),
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
        ),

        // ---- MODAL AddCompanyModal ----
        if (_showAdd)
          AddCompanyModal(
            onCancel: () => setState(() => _showAdd = false),
            onSuccess: () {
              _loadCompanies();
              setState(() => _showAdd = false);
            },
          ),

        // ---- MODAL ManageCompanyModal ----
        if (_showManage && _selectedCompany != null)
          ManageCompanyModal(
            selectedCompany: _selectedCompany!,
            onClose: () => setState(() => _showManage = false),
          ),
      ],
    );
  }
}
