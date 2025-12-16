import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';

class NotificationPanel extends StatefulWidget {
  final VoidCallback onClose;
  final double width;

  const NotificationPanel({
    super.key,
    required this.onClose,
    this.width = 380,
  });

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  bool showUnreadOnly = false;

  // Dane powiadomień jako lista map
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'course',
      'title': 'Nowy kurs przypisany',
      'message': 'Przypisano Ci kurs „TypeScript Zaawansowany”',
      'time': '5 min temu',
      'read': false,
    },
    {
      'id': '2',
      'type': 'completion',
      'title': 'Gratulacje!',
      'message': 'Ukończyłeś kurs „Wprowadzenie do React”',
      'time': '2 godz. temu',
      'read': false,
    },
    {
      'id': '3',
      'type': 'reminder',
      'title': 'Przypomnienie',
      'message': 'Masz 2 dni na ukończenie kursu „Git i GitHub”',
      'time': '1 dzień temu',
      'read': true,
    },
    {
      'id': '4',
      'type': 'system',
      'title': 'Aktualizacja systemu',
      'message': 'Platforma zostanie zaktualizowana 20.12.2024',
      'time': '2 dni temu',
      'read': true,
    },
  ];

  int get unreadCount =>
      _notifications.where((n) => n['read'] == false).length;

  List<Map<String, dynamic>> get filtered => showUnreadOnly
      ? _notifications.where((n) => n['read'] == false).toList()
      : _notifications;

  void markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n['read'] = true;
      }
    });
  }

  void markAsRead(Map<String, dynamic> n) {
    setState(() => n['read'] = true);
  }

  void deleteNotification(Map<String, dynamic> n) {
    setState(() => _notifications.remove(n));
  }

  Icon _iconForType(String type) {
    switch (type) {
      case 'course':
        return const Icon(Icons.book, color: Tokens.blue700, size: 16);
      case 'completion':
        return const Icon(Icons.check, color: Tokens.green700, size: 16);
      case 'reminder':
        return const Icon(Icons.access_time, color: Tokens.textMuted2, size: 16);
      case 'system':
        return const Icon(Icons.info, color: Tokens.purple700, size: 16);
      default:
        return const Icon(Icons.notifications, size: 16);
    }
  }

  Color _bgForType(String type, bool read) {
    if (!read) return Tokens.blue100.withOpacity(0.3);
    switch (type) {
      case 'course':
        return Tokens.blue100;
      case 'completion':
        return Tokens.green100;
      case 'reminder':
        return Tokens.gray100;
      case 'system':
        return Tokens.purple100;
      default:
        return Tokens.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 68,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(Tokens.radius2xl),
        child: Container(
          width: widget.width,
          constraints: BoxConstraints(
            maxHeight: 520,
            maxWidth: MediaQuery.of(context).size.width - 32,
          ),

          decoration: BoxDecoration(
            color: Tokens.surface,
            borderRadius: BorderRadius.circular(Tokens.radius2xl),
            border: Border.all(color: Tokens.gray200),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Tokens.blue),
                        const SizedBox(width: 8),
                        const Text('Powiadomienia', style: TextStyle(fontWeight: FontWeight.bold)),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Tokens.blue,
                              borderRadius: BorderRadius.circular(Tokens.radiusLg),
                            ),
                            child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        const Spacer(),
                        IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => showUnreadOnly = false),
                          style: TextButton.styleFrom(
                            backgroundColor: showUnreadOnly ? Tokens.gray50 : Tokens.blue,
                            foregroundColor: showUnreadOnly ? Tokens.textMuted2 : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Tokens.radiusLg)),
                          ),
                          child: const Text('Wszystkie'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => setState(() => showUnreadOnly = true),
                          style: TextButton.styleFrom(
                            backgroundColor: showUnreadOnly ? Tokens.blue : Tokens.gray50,
                            foregroundColor: showUnreadOnly ? Colors.white : Tokens.textMuted2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Tokens.radiusLg)),
                          ),
                          child: const Text('Nieprzeczytane'),
                        ),
                        const Spacer(),
                        if (unreadCount > 0)
                          IconButton(
                            onPressed: markAllAsRead,
                            icon: const Icon(Icons.check),
                            tooltip: 'Oznacz wszystkie jako przeczytane',
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Lista powiadomień
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_off, size: 48, color: Tokens.textMuted2.withOpacity(0.5)),
                              const SizedBox(height: 12),
                              Text(
                                showUnreadOnly ? 'Brak nieprzeczytanych powiadomień' : 'Brak powiadomień',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Tokens.textMuted2),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Tokens.gray200),
                        itemBuilder: (context, index) {
                          final n = filtered[index];
                          return Container(
                            color: n['read'] ? Tokens.surface : Tokens.blue100.withOpacity(0.3),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: _bgForType(n['type'], n['read']),
                                  child: _iconForType(n['type']),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => markAsRead(n),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(n['title'], style: TextStyle(fontWeight: n['read'] ? FontWeight.normal : FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(n['message'], style: const TextStyle(fontSize: 12)),
                                        const SizedBox(height: 2),
                                        Text(n['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(onPressed: () => markAsRead(n), icon: const Icon(Icons.check)),
                                IconButton(onPressed: () => deleteNotification(n), icon: const Icon(Icons.delete, color: Tokens.destructive)),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Footer
              if (filtered.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border(top: BorderSide(color: Tokens.gray200))),
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Zobacz wszystkie powiadomienia', style: TextStyle(color: Tokens.blue)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
