import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/models/mentor_model.dart';
import '../../../data/services/mentor_service.dart';

class MentorAssignmentScreen extends StatefulWidget {
  final String? taskTitle;
  final VoidCallback onBack;
  final Function(String mentorId)? onAssign;

  const MentorAssignmentScreen({
    super.key,
    this.taskTitle,
    required this.onBack,
    this.onAssign,
  });

  @override
  State<MentorAssignmentScreen> createState() => _MentorAssignmentScreenState();
}

class _MentorAssignmentScreenState extends State<MentorAssignmentScreen> {
  String _search = '';
  String _filterDept = 'all';
  MentorModel? _selectedMentor;
  bool _confirmed = false;
  bool _loading = true;
  List<MentorModel> _mentors = [];

  final Map<String, Map<String, Color>> _deptColors = {
    'Engineering': {
      'bg': const Color(0xFFEFF6FF), // bg-blue-50
      'text': const Color(0xFF1D4ED8), // text-blue-700
    },
    'Human Resources': {
      'bg': const Color(0xFFF3E8FF), // bg-purple-50
      'text': const Color(0xFF7C3AED), // text-purple-700
    },
    'Product': {
      'bg': const Color(0xFFECFDF5), // bg-green-50
      'text': const Color(0xFF047857), // text-green-700
    },
    'Infrastructure': {
      'bg': const Color(0xFFFFF7ED), // bg-orange-50
      'text': const Color(0xFFC2410C), // text-orange-700
    },
  };

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    try {
      final data = await MentorService.fetchMentors();
      setState(() {
        _mentors = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Błąd pobierania mentorów: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleAssign() async {
    if (_selectedMentor == null) return;
    setState(() {
      _loading = true;
    });

    try {
      final success = await MentorService.assignMentor(_selectedMentor!.id, widget.taskTitle);
      if (success) {
        if (widget.onAssign != null) {
          widget.onAssign!(_selectedMentor!.id);
        }
        setState(() {
          _confirmed = true;
        });
      }
    } catch (e) {
      debugPrint('Błąd przypisywania mentora: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmed && _selectedMentor != null) {
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
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7), // bg-green-100
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 40,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Mentor przypisany!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Tokens.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: '',
                      children: [
                        TextSpan(
                          text: _selectedMentor!.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Tokens.textDark),
                        ),
                        const TextSpan(text: ' został przypisany do zadania.'),
                      ],
                    ),
                    style: const TextStyle(fontSize: 14, color: Tokens.textMuted2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Tokens.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Powrót do zadania',
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

    // Prepare departments
    final List<String> depts = ['all'];
    for (final m in _mentors) {
      if (!depts.contains(m.department)) {
        depts.add(m.department);
      }
    }

    // Filter mentors
    final filtered = _mentors.where((m) {
      if (_filterDept != 'all' && m.department != _filterDept) return false;
      if (_search.isNotEmpty) {
        final matchesName = m.name.toLowerCase().contains(_search.toLowerCase());
        final matchesExpertise = m.expertise.any((e) => e.toLowerCase().contains(_search.toLowerCase()));
        if (!matchesName && !matchesExpertise) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Tokens.gray50,
      body: Stack(
        children: [
          _loading && _mentors.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header + Back button
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: widget.onBack,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Tokens.textMuted2,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  side: const BorderSide(color: Tokens.gray200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                child: const Text('← Powrót'),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Przypisz mentora',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Tokens.textDark,
                                      ),
                                    ),
                                    if (widget.taskTitle != null) ...[
                                      const SizedBox(height: 2),
                                      Text.rich(
                                        TextSpan(
                                          text: 'do zadania: ',
                                          style: const TextStyle(fontSize: 13, color: Tokens.textMuted2),
                                          children: [
                                            TextSpan(
                                              text: widget.taskTitle!,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Tokens.textDark),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Search & Filters Row
                          LayoutBuilder(builder: (context, constraints) {
                            final bool isWide = constraints.maxWidth > 600;
                            final searchBar = TextField(
                              onChanged: (val) {
                                setState(() {
                                    _search = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Szukaj po nazwisku lub ekspertyzie...',
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

                            final filterTabs = SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: depts.map((dept) {
                                  final bool isSelected = _filterDept == dept;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(dept == 'all' ? 'Wszyscy' : dept),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _filterDept = dept;
                                        });
                                      },
                                      selectedColor: Tokens.blue,
                                      backgroundColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: isSelected ? Colors.white : Tokens.textMuted2,
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: isSelected ? Tokens.blue : Tokens.gray200,
                                        ),
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
                                      Expanded(child: searchBar),
                                      const SizedBox(width: 16),
                                      filterTabs,
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      searchBar,
                                      const SizedBox(height: 12),
                                      filterTabs,
                                    ],
                                  );
                          }),
                          const SizedBox(height: 24),

                          // Mentors Grid
                          LayoutBuilder(builder: (context, constraints) {
                            final int columns = constraints.maxWidth > 600 ? 2 : 1;
                            if (filtered.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: Text(
                                    'Brak mentorów spełniających kryteria wyszukiwania.',
                                    style: TextStyle(color: Tokens.textMuted2),
                                  ),
                                ),
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 2.2,
                              ),
                              itemBuilder: (context, idx) {
                                final mentor = filtered[idx];
                                final bool isSelected = _selectedMentor?.id == mentor.id;
                                final String initials = mentor.name
                                    .split(' ')
                                    .map((n) => n.isNotEmpty ? n[0] : '')
                                    .join('');
                                final deptColor = _deptColors[mentor.department] ??
                                    {
                                      'bg': Tokens.gray100,
                                      'text': Tokens.gray700,
                                    };

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedMentor = mentor;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(Tokens.radius2xl),
                                      border: Border.all(
                                        color: isSelected ? Tokens.blue : Tokens.gray200,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: isSelected ? Tokens.shadowMd : Tokens.shadowSm,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [Tokens.blue, Colors.purple],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            initials,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      mentor.name,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Tokens.textDark,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    const Icon(
                                                      Icons.check_circle,
                                                      color: Tokens.blue,
                                                      size: 20,
                                                    ),
                                                ],
                                              ),
                                              Text(
                                                mentor.role,
                                                style: const TextStyle(
                                                  color: Tokens.textMuted2,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    mentor.rating.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: Tokens.textDark,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    '(${mentor.reviewCount})',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: deptColor['bg'],
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      mentor.department,
                                                      style: TextStyle(
                                                        color: deptColor['text'],
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.people_outline,
                                                    color: Colors.grey,
                                                    size: 13,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${mentor.activeTasksCount} aktywnych zadań',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Tokens.textMuted2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  children: mentor.expertise.map((exp) {
                                                    return Padding(
                                                      padding: const EdgeInsets.only(right: 4),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: Tokens.gray100,
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                        child: Text(
                                                          exp,
                                                          style: const TextStyle(
                                                            color: Tokens.textMuted2,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),

      // Sticky Bottom Confirmation Bar
      bottomSheet: _selectedMentor != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: const Border(
                  top: BorderSide(color: Tokens.gray200),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Tokens.blue, Colors.purple],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _selectedMentor!.name
                          .split(' ')
                          .map((n) => n.isNotEmpty ? n[0] : '')
                          .join(''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Wybrany: ',
                            style: const TextStyle(fontSize: 12, color: Tokens.textMuted2),
                            children: [
                              TextSpan(
                                text: _selectedMentor!.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Tokens.textDark),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _selectedMentor!.role,
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _handleAssign,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Tokens.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Przypisz',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
                  )
                ],
              ),
            )
          : null,
    );
  }
}
