import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../data/services/mentor_service.dart';

class MentorRatingScreen extends StatefulWidget {
  final String? taskTitle;
  final String mentorName;
  final String mentorId; // DODANE POLE
  final VoidCallback onBack;

  const MentorRatingScreen({
    super.key,
    this.taskTitle,
    this.mentorName = 'Nieznany Mentor',
    this.mentorId = '1', // Wartość domyślna, by nie zepsuć kompilacji w routerze
    required this.onBack,
  });

  @override
  State<MentorRatingScreen> createState() => _MentorRatingScreenState();
}

class _MentorRatingScreenState extends State<MentorRatingScreen> {
  int _overallRating = 0;
  int _hoveredStar = 0;
  final Map<String, int> _criteriaRatings = {};
  final List<String> _tags = [];
  final TextEditingController _commentController = TextEditingController();
  bool _submitted = false;
  bool _submitting = false;

  final List<String> _positiveTags = [
    'Dostępny',
    'Cierpliwy',
    'Świetnie tłumaczy',
    'Pomocny',
    'Merytoryczny',
    'Motywujący',
  ];

  final List<Map<String, String>> _criteria = [
    {
      'id': 'availability',
      'label': 'Dostępność',
      'description': 'Czy mentor był dostępny gdy tego potrzebowałeś?'
    },
    {
      'id': 'knowledge',
      'label': 'Wiedza',
      'description': 'Jak oceniasz wiedzę merytoryczną mentora?'
    },
    {
      'id': 'communication',
      'label': 'Komunikacja',
      'description': 'Czy mentor jasno wyjaśniał zagadnienia?'
    },
    {
      'id': 'support',
      'label': 'Wsparcie',
      'description': 'Jak bardzo czułeś się wspierany?'
    },
  ];

  final List<String> _ratingLabels = [
    '',
    'Słabo',
    'Poniżej oczekiwań',
    'W porządku',
    'Dobrze',
    'Doskonale!'
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_tags.contains(tag)) {
        _tags.remove(tag);
      } else {
        _tags.add(tag);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (_overallRating == 0 || _submitting) return;

    setState(() {
      _submitting = true;
    });

    try {
      final success = await MentorService.submitRating(
        mentorId: widget.mentorId, // Default simulation ID
        rating: _overallRating,
        comment: _commentController.text,
        criteriaRatings: _criteriaRatings,
        tags: _tags,
      );

      if (success) {
        setState(() {
          _submitted = true;
        });
      }
    } catch (e) {
      debugPrint('Błąd przy przesyłaniu opinii: $e');
    } finally {
      setState(() {
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
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
                      color: Color(0xFFFEF3C7), // bg-amber-100
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 40,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Dziękujemy za ocenę!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Tokens.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Twoja opinia pomoże nam poprawić jakość mentoringu w organizacji.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Tokens.textMuted2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return Icon(
                        Icons.star,
                        size: 32,
                        color: i < _overallRating
                            ? Colors.amber.shade400
                            : Tokens.gray200,
                      );
                    }),
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
                        'Powrót',
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

    final String initials = widget.mentorName
        .split(' ')
        .map((n) => n.isNotEmpty ? n[0] : '')
        .join('');

    return Scaffold(
      backgroundColor: Tokens.gray50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header + Back
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
                    const Text(
                      'Oceń mentora',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Tokens.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Mentor Info Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                    side: const BorderSide(color: Tokens.gray200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.purple, Tokens.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mentorName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Tokens.textDark,
                                ),
                              ),
                              const Text(
                                'Senior Developer · Engineering',
                                style: TextStyle(
                                  color: Tokens.textMuted2,
                                  fontSize: 14,
                                ),
                              ),
                              if (widget.taskTitle != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Zadanie: ${widget.taskTitle}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Overall Rating Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                    side: const BorderSide(color: Tokens.gray200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Ocena ogólna',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Tokens.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Jak oceniasz współpracę z tym mentorem?',
                          style: TextStyle(color: Tokens.textMuted2, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            final int starVal = i + 1;
                            final bool active = starVal <= (_hoveredStar != 0 ? _hoveredStar : _overallRating);
                            return MouseRegion(
                              onEnter: (_) => setState(() => _hoveredStar = starVal),
                              onExit: (_) => setState(() => _hoveredStar = 0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.star,
                                  size: 38,
                                  color: active ? Colors.amber.shade400 : Tokens.gray200,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _overallRating = starVal;
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        if (_hoveredStar > 0 || _overallRating > 0)
                          Text(
                            _ratingLabels[_hoveredStar > 0 ? _hoveredStar : _overallRating],
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Criteria Ratings Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                    side: const BorderSide(color: Tokens.gray200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Szczegółowe kryteria',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Tokens.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._criteria.map((c) {
                          final String id = c['id']!;
                          final int score = _criteriaRatings[id] ?? 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c['label']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Tokens.textDark,
                                        ),
                                      ),
                                      Text(
                                        c['description']!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (i) {
                                    return IconButton(
                                      icon: Icon(
                                        Icons.star,
                                        size: 22,
                                        color: score > i ? Colors.amber.shade400 : Tokens.gray200,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      onPressed: () {
                                        setState(() {
                                          _criteriaRatings[id] = i + 1;
                                        });
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Positive Tags Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                    side: const BorderSide(color: Tokens.gray200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.thumb_up_alt_outlined, color: Tokens.blue, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Co szczególnie cenisz?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Tokens.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _positiveTags.map((tag) {
                            final bool active = _tags.contains(tag);
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _toggleTag(tag),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: active ? Tokens.blue : Tokens.gray50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: active ? Tokens.blue : Tokens.gray200,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: active ? Colors.white : Tokens.textMuted2,
                                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Comment Area Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Tokens.radius2xl),
                    side: const BorderSide(color: Tokens.gray200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.message_outlined, color: Tokens.blue, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Komentarz (opcjonalny)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Tokens.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _commentController,
                          maxLines: 4,
                          maxLength: 500,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Podziel się swoimi wrażeniami ze współpracy z mentorem...',
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Tokens.textMuted2,
                          side: const BorderSide(color: Tokens.gray200),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Anuluj'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _overallRating > 0 && !_submitting ? _handleSubmit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Tokens.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Tokens.gray200,
                          disabledForegroundColor: Colors.grey,
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Text('Wyślij ocenę', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
