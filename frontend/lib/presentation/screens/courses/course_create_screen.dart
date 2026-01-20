import 'package:flutter/material.dart';
import '../../ui/app_card.dart';
import '../../ui/input.dart';
import '../../ui/app_button.dart';
import '../../../core/constants/design_tokens.dart';

enum BlockType { text, image, video, quiz }

class QuizQuestion {
  final TextEditingController questionController;
  final List<TextEditingController> answersControllers;
  int correctAnswerIndex = -1;

  QuizQuestion()
      : questionController = TextEditingController(),
        answersControllers = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];

  void dispose() {
    questionController.dispose();
    for (var controller in answersControllers) {
      controller.dispose();
    }
  }
}

class CourseBlock {
  final String id;
  final BlockType type;
  final TextEditingController contentController;
  QuizQuestion? quizQuestion;

  CourseBlock({
    required this.id,
    required this.type,
  }) : contentController = TextEditingController() {
    if (type == BlockType.quiz) {
      quizQuestion = QuizQuestion();
    }
  }

  void dispose() {
    contentController.dispose();
    quizQuestion?.dispose();
  }
}

class CourseSection {
  final String id;
  final TextEditingController titleController;
  final List<CourseBlock> blocks;

  CourseSection({
    required this.id,
  })  : titleController = TextEditingController(),
        blocks = [];

  void addBlock(BlockType type) {
    blocks.add(
      CourseBlock(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
      ),
    );
  }

  void removeBlock(String blockId) {
    final block = blocks.firstWhere((b) => b.id == blockId);
    block.dispose();
    blocks.removeWhere((b) => b.id == blockId);
  }

  void dispose() {
    titleController.dispose();
    for (var block in blocks) {
      block.dispose();
    }
  }
}

class CourseCreateScreen extends StatefulWidget {
  const CourseCreateScreen({super.key});

  @override
  State<CourseCreateScreen> createState() => _CourseCreateScreenState();
}

class _CourseCreateScreenState extends State<CourseCreateScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _thumbnailController;
  final List<CourseSection> _sections = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _thumbnailController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _thumbnailController.dispose();
    for (var section in _sections) {
      section.dispose();
    }
    super.dispose();
  }

  void _addSection() {
    setState(() {
      _sections.add(
        CourseSection(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );
    });
  }

  void _removeSection(String sectionId) {
    setState(() {
      final section = _sections.firstWhere((s) => s.id == sectionId);
      section.dispose();
      _sections.removeWhere((s) => s.id == sectionId);
    });
  }

  void _addBlockToSection(String sectionId, BlockType type) {
    setState(() {
      final section = _sections.firstWhere((s) => s.id == sectionId);
      section.addBlock(type);
    });
  }

  void _removeBlockFromSection(String sectionId, String blockId) {
    setState(() {
      final section = _sections.firstWhere((s) => s.id == sectionId);
      section.removeBlock(blockId);
    });
  }

  String _getBlockTypeLabel(BlockType type) {
    switch (type) {
      case BlockType.text:
        return 'Blok tekstu';
      case BlockType.image:
        return 'Obraz';
      case BlockType.video:
        return 'Wideo';
      case BlockType.quiz:
        return 'Quiz';
    }
  }

  IconData _getBlockTypeIcon(BlockType type) {
    switch (type) {
      case BlockType.text:
        return Icons.text_fields;
      case BlockType.image:
        return Icons.image;
      case BlockType.video:
        return Icons.videocam;
      case BlockType.quiz:
        return Icons.quiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tworzenie kursu"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            width: 1000,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nagłówek
                  Text(
                    'Tworzenie nowego kursu',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wypełnij informacje i dodaj zawartość kursu',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 28),

                  // Informacje o kursie
                  Text(
                    'Informacje o kursie',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppInput(
                          controller: _titleController,
                          labelText: 'Tytuł kursu',
                          hintText: 'np. Wprowadzenie do React',
                        ),
                        const SizedBox(height: 16),
                        AppInput(
                          controller: _descController,
                          labelText: 'Opis',
                          hintText:
                              'Opisz czego użytkownicy nauczą się w tym kursie...',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Miniatura kursu
                  Text(
                    'Miniatura kursu',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(Tokens.radius),
                            color: Colors.grey[100],
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.grey[400],
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Prześlij obraz',
                          onPressed: () {},
                          primary: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Sekcje kursu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sekcje kursu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ElevatedButton.icon(
                        onPressed: _addSection,
                        icon: const Icon(Icons.add),
                        label: const Text('Dodaj sekcję'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Lista sekcji
                  if (_sections.isEmpty)
                    AppCard(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Brak sekcji. Dodaj sekcję aby rozpocząć.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _sections.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        final section = _sections[idx];
                        return _buildSectionCard(context, section);
                      },
                    ),

                  const SizedBox(height: 28),

                  // Przyciski akcji
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Opublikuj',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kurs opublikowany (mock)!'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          primary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Anuluj'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, CourseSection section) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nagłówek sekcji
          Row(
            children: [
              Icon(Icons.drag_indicator, color: Colors.grey[400]),
              const SizedBox(width: 12),
              Expanded(
                child: AppInput(
                  controller: section.titleController,
                  labelText: 'Tytuł sekcji',
                  hintText: 'np. Podstawy',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: () => _removeSection(section.id),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bloki w sekcji
          if (section.blocks.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bloki',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: section.blocks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final block = section.blocks[idx];
                    return _buildBlockCard(
                      context,
                      section.id,
                      block,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),

          // Przycisk dodaj blok
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAddBlockButton(
                context,
                section.id,
                BlockType.text,
                Icons.text_fields,
                'Blok tekstu',
              ),
              _buildAddBlockButton(
                context,
                section.id,
                BlockType.image,
                Icons.image,
                'Obraz',
              ),
              _buildAddBlockButton(
                context,
                section.id,
                BlockType.video,
                Icons.videocam,
                'Wideo',
              ),
              _buildAddBlockButton(
                context,
                section.id,
                BlockType.quiz,
                Icons.quiz,
                'Quiz',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlockCard(
    BuildContext context,
    String sectionId,
    CourseBlock block,
  ) {
    if (block.type == BlockType.quiz && block.quizQuestion != null) {
      return _buildQuizBlockCard(context, sectionId, block);
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(Tokens.radius),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            _getBlockTypeIcon(block.type),
            color: Tokens.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppInput(
              controller: block.contentController,
              labelText: _getBlockTypeLabel(block.type),
              hintText: block.type == BlockType.image
                  ? 'URL obrazu...'
                  : block.type == BlockType.video
                      ? 'URL wideo...'
                      : 'Wpisz treść...',
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red,
            onPressed: () => _removeBlockFromSection(sectionId, block.id),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBlockCard(
    BuildContext context,
    String sectionId,
    CourseBlock block,
  ) {
    final quiz = block.quizQuestion!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(Tokens.radius),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nagłówek
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.quiz,
                    color: Tokens.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Quiz',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                onPressed: () => _removeBlockFromSection(sectionId, block.id),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pytanie
          AppInput(
            controller: quiz.questionController,
            labelText: 'Pytanie',
            hintText: 'Wpisz pytanie...',
          ),
          const SizedBox(height: 16),

          // Odpowiedzi
          Text(
            'Odpowiedzi',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              return _buildAnswerInput(
                context,
                quiz,
                idx,
                () => setState(() => quiz.correctAnswerIndex = idx),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(
    BuildContext context,
    QuizQuestion quiz,
    int index,
    VoidCallback onMarkCorrect,
  ) {
    final isCorrect = quiz.correctAnswerIndex == index;

    return Row(
      children: [
        Checkbox(
          value: isCorrect,
          onChanged: (_) => onMarkCorrect(),
          activeColor: Colors.green,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppInput(
            controller: quiz.answersControllers[index],
            labelText: 'Odpowiedź ${index + 1}',
            hintText: 'Wpisz odpowiedź...',
          ),
        ),
      ],
    );
  }

  Widget _buildAddBlockButton(
    BuildContext context,
    String sectionId,
    BlockType type,
    IconData icon,
    String label,
  ) {
    return OutlinedButton.icon(
      onPressed: () => _addBlockToSection(sectionId, type),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
