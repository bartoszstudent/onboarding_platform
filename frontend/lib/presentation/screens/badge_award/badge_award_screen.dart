import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/models/badge_model.dart';
import '../../../data/services/badge_service.dart';

class BadgeAwardScreen extends StatefulWidget {
  const BadgeAwardScreen({super.key});

  @override
  State<BadgeAwardScreen> createState() => _BadgeAwardScreenState();
}

class _BadgeAwardScreenState extends State<BadgeAwardScreen> {
  String _step = 'select-employee'; // select-employee, select-badge, confirm, done
  String _searchEmployee = '';
  String _searchBadge = '';
  EmployeeModel? _selectedEmployee;
  BadgeModel? _selectedBadge;
  String _message = '';
  String _categoryFilter = 'all';

  List<EmployeeModel> _employees = [];
  List<BadgeModel> _badges = [];
  bool _loading = true;
  bool _submitting = false;

  final Map<BadgeRarity, Map<String, dynamic>> _rarityConfigs = {
    BadgeRarity.common: {
      'label': 'Pospolita',
      'color': const Color(0xFFF1F5F9), // bg-gray-100
      'text': const Color(0xFF374151), // text-gray-700
      'border': const Color(0xFFCBD5E1),
    },
    BadgeRarity.rare: {
      'label': 'Rzadka',
      'color': const Color(0xFFEFF6FF), // bg-blue-50
      'text': const Color(0xFF1D4ED8), // text-blue-700
      'border': const Color(0xFF93C5FD),
    },
    BadgeRarity.epic: {
      'label': 'Epicka',
      'color': const Color(0xFFF3E8FF), // bg-purple-50
      'text': const Color(0xFF7C3AED), // text-purple-700
      'border': const Color(0xFFC084FC),
    },
    BadgeRarity.legendary: {
      'label': 'Legendarna',
      'color': const Color(0xFFFEF3C7), // bg-amber-50
      'text': const Color(0xFFD97706), // text-amber-700
      'border': const Color(0xFFFBBF24),
    },
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final emps = await BadgeService.fetchEmployees();
      final bdgs = await BadgeService.fetchAllBadges();
      setState(() {
        _employees = emps;
        _badges = bdgs;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Błąd wczytywania danych odznak/pracowników: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleAward() async {
    if (_selectedEmployee == null || _selectedBadge == null || _submitting) return;

    setState(() {
      _submitting = true;
    });

    try {
      final success = await BadgeService.awardBadge(
        _selectedEmployee!.id,
        _selectedBadge!.id,
        _message,
      );

      if (success) {
        // Refresh employee data to reflect awarded badge in next search/session
        final updatedEmps = await BadgeService.fetchEmployees();
        setState(() {
          _employees = updatedEmps;
          _step = 'done';
        });
      }
    } catch (e) {
      debugPrint('Błąd przyznawania odznaki: $e');
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _step = 'select-employee';
      _selectedEmployee = null;
      _selectedBadge = null;
      _message = '';
      _searchEmployee = '';
      _searchBadge = '';
      _categoryFilter = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 'done' && _selectedEmployee != null && _selectedBadge != null) {
      return Scaffold(
        backgroundColor: Tokens.gray50,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Tokens.radius2xl),
                boxShadow: Tokens.shadowMd,
                border: Border.all(color: Tokens.gray200),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7), // bg-amber-50
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _selectedBadge!.emoji,
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Odznaka przyznana! 🎉',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Tokens.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      text: '',
                      children: [
                        TextSpan(
                          text: _selectedEmployee!.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Tokens.textDark),
                        ),
                        const TextSpan(text: ' otrzymał odznakę '),
                        TextSpan(
                          text: '"${_selectedBadge!.name}"',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Tokens.textDark),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 14, color: Tokens.textMuted2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+${_selectedBadge!.xpReward} XP dodane do konta',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Tokens.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Przyznaj kolejną',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Prepare categories
    final List<String> categories = ['all'];
    for (final b in _badges) {
      if (!categories.contains(b.category)) {
        categories.add(b.category);
      }
    }

    // Filters
    final filteredEmployees = _employees.where((e) {
      return _searchEmployee.isEmpty || e.name.toLowerCase().contains(_searchEmployee.toLowerCase());
    }).toList();

    final filteredBadges = _badges.where((b) {
      if (_categoryFilter != 'all' && b.category != _categoryFilter) return false;
      return _searchBadge.isEmpty || b.name.toLowerCase().contains(_searchBadge.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Tokens.gray50,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Przyznaj odznakę',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Tokens.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Doceniaj pracowników za ich wkład i osiągnięcia',
                        style: TextStyle(color: Tokens.textMuted2, fontSize: 13),
                      ),
                      const SizedBox(height: 24),

                      // Steps indicator
                      _buildStepsIndicator(),
                      const SizedBox(height: 24),

                      // STEP 1: Select Employee
                      if (_step == 'select-employee') ...[
                        // Search bar
                        TextField(
                          onChanged: (val) => setState(() => _searchEmployee = val),
                          decoration: InputDecoration(
                            hintText: 'Szukaj pracownika...',
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Tokens.gray200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Tokens.gray200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Tokens.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Employees Grid
                        LayoutBuilder(builder: (context, constraints) {
                          final int columns = constraints.maxWidth > 550 ? 2 : 1;
                          if (filteredEmployees.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Text('Brak pracowników.', style: TextStyle(color: Tokens.textMuted2)),
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredEmployees.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.8,
                            ),
                            itemBuilder: (context, idx) {
                              final emp = filteredEmployees[idx];
                              final String initials = emp.name
                                  .split(' ')
                                  .map((n) => n.isNotEmpty ? n[0] : '')
                                  .join('');

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedEmployee = emp;
                                    _step = 'select-badge';
                                  });
                                },
                                borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                    border: Border.all(color: Tokens.gray200),
                                    boxShadow: Tokens.shadowSm,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [Tokens.blue, Colors.purple],
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              emp.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Tokens.textDark,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              emp.role,
                                              style: const TextStyle(
                                                color: Tokens.textMuted2,
                                                fontSize: 11,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.workspace_premium_outlined,
                                                  color: emp.badges.isNotEmpty ? Colors.amber : Colors.grey,
                                                  size: 13,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  emp.badges.isNotEmpty
                                                      ? '${emp.badges.length} odznak'
                                                      : 'Brak odznak',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],

                      // STEP 2: Select Badge
                      if (_step == 'select-badge' && _selectedEmployee != null) ...[
                        // Selected employee banner
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF), // bg-blue-50
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [Tokens.blue, Colors.purple]),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _selectedEmployee!.name
                                      .split(' ')
                                      .map((n) => n.isNotEmpty ? n[0] : '')
                                      .join(''),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedEmployee!.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Tokens.textDark),
                                    ),
                                    Text(
                                      _selectedEmployee!.role,
                                      style: const TextStyle(fontSize: 11, color: Tokens.textMuted2),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _step = 'select-employee';
                                  });
                                },
                                child: const Text(
                                  'Zmień',
                                  style: TextStyle(color: Tokens.blue, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Search and Filters
                        LayoutBuilder(builder: (context, constraints) {
                          final bool isWide = constraints.maxWidth > 550;
                          final searchInput = TextField(
                            onChanged: (val) => setState(() => _searchBadge = val),
                            decoration: InputDecoration(
                              hintText: 'Szukaj odznaki...',
                              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Tokens.gray200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Tokens.gray200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Tokens.blue),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          );

                          final filters = SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categories.map((c) {
                                final bool isSelected = _categoryFilter == c;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: ChoiceChip(
                                    label: Text(c == 'all' ? 'Wszyscy' : c),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(() {
                                        _categoryFilter = c;
                                      });
                                    },
                                    selectedColor: Tokens.blue,
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : Tokens.textMuted2,
                                      fontSize: 11,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: isSelected ? Tokens.blue : Tokens.gray200),
                                    ),
                                    showCheckmark: false,
                                  ),
                                );
                              }).toList(),
                            ),
                          );

                          return isWide
                              ? Row(
                                  children: [
                                    Expanded(child: searchInput),
                                    const SizedBox(width: 12),
                                    filters,
                                  ],
                                )
                              : Column(
                                  children: [
                                    searchInput,
                                    const SizedBox(height: 12),
                                    filters,
                                  ],
                                );
                        }),
                        const SizedBox(height: 16),

                        // Badges Grid
                        LayoutBuilder(builder: (context, constraints) {
                          final int columns = constraints.maxWidth > 550 ? 2 : 1;
                          if (filteredBadges.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Text('Brak odznak.', style: TextStyle(color: Tokens.textMuted2)),
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredBadges.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.3,
                            ),
                            itemBuilder: (context, idx) {
                              final badge = filteredBadges[idx];
                              final bool alreadyHas = _selectedEmployee!.badges.contains(badge.id);
                              final rarityConfig = _rarityConfigs[badge.rarity]!;

                              return InkWell(
                                onTap: alreadyHas
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedBadge = badge;
                                          _step = 'confirm';
                                        });
                                      },
                                borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                child: Opacity(
                                  opacity: alreadyHas ? 0.5 : 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                      border: Border.all(
                                        color: alreadyHas ? Tokens.gray100 : Tokens.gray200,
                                      ),
                                      boxShadow: alreadyHas ? null : Tokens.shadowSm,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: Tokens.gray50,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            badge.emoji,
                                            style: const TextStyle(fontSize: 26),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      badge.name,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                        color: Tokens.textDark,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (alreadyHas)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFDCFCE7),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: const Text(
                                                        'Posiada',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                badge.description,
                                                style: const TextStyle(
                                                  color: Tokens.textMuted2,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: rarityConfig['color'],
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      rarityConfig['label'],
                                                      style: TextStyle(
                                                        color: rarityConfig['text'],
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star, color: Colors.amber, size: 12),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        '+${badge.xpReward} XP',
                                                        style: const TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],

                      // STEP 3: Confirm
                      if (_step == 'confirm' && _selectedEmployee != null && _selectedBadge != null) ...[
                        Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge details card
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                    side: const BorderSide(color: Tokens.gray200),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                        Text(
                                          _selectedBadge!.emoji,
                                          style: const TextStyle(fontSize: 56),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _selectedBadge!.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Tokens.textDark,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _selectedBadge!.description,
                                          style: const TextStyle(color: Tokens.textMuted2, fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _rarityConfigs[_selectedBadge!.rarity]!['color'],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _rarityConfigs[_selectedBadge!.rarity]!['label'],
                                                style: TextStyle(
                                                  color: _rarityConfigs[_selectedBadge!.rarity]!['text'],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Row(
                                              children: [
                                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '+${_selectedBadge!.xpReward} XP',
                                                  style: const TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Selected Employee row info
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Tokens.gray50,
                                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                    border: Border.all(color: Tokens.gray200),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.people_outline, color: Tokens.blue),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Przyznasz odznakę dla:',
                                              style: TextStyle(color: Tokens.textMuted2, fontSize: 11),
                                            ),
                                            Text(
                                              _selectedEmployee!.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Tokens.textDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _step = 'select-employee';
                                          });
                                        },
                                        child: const Text(
                                          'Zmień',
                                          style: TextStyle(color: Tokens.blue, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Message field
                                const Text(
                                  'Wiadomość dla pracownika (opcjonalna)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Tokens.textMuted2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  maxLines: 3,
                                  onChanged: (val) {
                                    setState(() {
                                      _message = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Napisz kilka słów pochwalnych...',
                                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Tokens.gray200),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Tokens.blue),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 14, color: Tokens.textMuted2),
                                ),
                                const SizedBox(height: 24),

                                // Confirm/Back buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            _step = 'select-badge';
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Tokens.textMuted2,
                                          side: const BorderSide(color: Tokens.gray200),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text('Wstecz'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _submitting ? null : _handleAward,
                                        icon: const Icon(Icons.workspace_premium_outlined, size: 18),
                                        label: _submitting
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                                ),
                                              )
                                            : const Text('Przyznaj odznakę'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Tokens.blue,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStepsIndicator() {
    final List<Map<String, String>> steps = [
      {'id': 'select-employee', 'label': '1. Wybierz pracownika'},
      {'id': 'select-badge', 'label': '2. Wybierz odznakę'},
      {'id': 'confirm', 'label': '3. Potwierdź'},
    ];

    final String currentStep = _step;
    final int currentIdx = steps.indexWhere((s) => s['id'] == currentStep);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(steps.length, (i) {
          final s = steps[i];
          final bool isActive = currentStep == s['id'];
          final bool isDone = currentIdx > i;

          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? Tokens.blue
                      : (isDone ? const Color(0xFFDCFCE7) : Tokens.gray100),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (isDone)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.check_circle, size: 14, color: Colors.green),
                      ),
                    Text(
                      s['label']!,
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : (isDone ? Colors.green.shade700 : const Color(0xFF94A3B8)),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < steps.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(width: 24, height: 1, color: Tokens.gray200),
                ),
            ],
          );
        }),
      ),
    );
  }
}
