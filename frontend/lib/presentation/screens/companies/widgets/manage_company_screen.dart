import 'package:flutter/material.dart';
import '../../../../core/constants/design_tokens.dart';

class ManageCompanyModal extends StatelessWidget {
  final Map<String, dynamic> selectedCompany;
  final VoidCallback onClose;

  const ManageCompanyModal({
    super.key,
    required this.selectedCompany,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 24 * 2 - 24) / 4;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              color: Tokens.surface,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nagłówek
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCompany['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Tokens.textDark,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  selectedCompany['subdomain'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Tokens.textMuted2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Tokens.textMuted2),
                            onPressed: onClose,
                          )
                        ],
                      ),
                      SizedBox(height: Tokens.spacingLg),

                      // Stats z Wrap
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: _StatCard(
                              title: 'Użytkownicy',
                              value: '${selectedCompany['employees']} / ${selectedCompany['maxUsers']}',
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _StatCard(
                              title: 'Kursy',
                              value: '${selectedCompany['courses']} / ${selectedCompany['maxCourses']}',
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _StatCard(
                              title: 'Administratorzy',
                              value: '${selectedCompany['admins'].length}',
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: _StatCard(
                              title: 'Status',
                              value: selectedCompany['status'] == 'active' ? 'Aktywna' : 'Nieaktywna',
                              isStatus: true,
                              statusActive: selectedCompany['status'] == 'active',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Tokens.spacingLg),

                      // Administrators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Administratorzy i HR",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Tokens.textDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Tokens.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // mniejszy
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Tokens.radiusLg),
                              ),
                            ),
                            child: const Text("+ Dodaj administratora", style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                      SizedBox(height: Tokens.spacingSm),
                      Column(
                        children: List.generate(selectedCompany['admins'].length, (index) {
                          final admin = selectedCompany['admins'][index];
                          final initials = (admin['name'] as String)
                              .split(' ')
                              .map((n) => n[0])
                              .join();
                          return Container(
                            margin: EdgeInsets.only(bottom: Tokens.spacingSm),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Tokens.gray50,
                              borderRadius: BorderRadius.circular(Tokens.radiusLg),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Tokens.blue,
                                          borderRadius: BorderRadius.circular(Tokens.radiusLg),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          initials,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              admin['name'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Tokens.textDark,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              admin['email'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Tokens.textMuted2,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: admin['role'] == 'admin' ? Colors.purple[100] : Colors.green[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        admin['role'] == 'admin' ? 'Administrator' : 'HR',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: admin['role'] == 'admin' ? Colors.purple[700] : Colors.green[700],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 18, color: Tokens.textMuted2),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, size: 18, color: Colors.red),
                                      onPressed: () {},
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: Tokens.spacingLg),

                      // Dolne akcje - mniejsze przyciski
                      GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 6, // bardziej wąskie i kompaktowe
                        ),
                        children: [
                          _ActionButton(
                            icon: Icons.settings,
                            label: 'Zaawansowane ustawienia',
                            onTap: () {},
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // mniejszy
                          ),
                          _ActionButton(
                            icon: Icons.book,
                            label: 'Zobacz wszystkie kursy',
                            onTap: () {},
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          _ActionButton(
                            icon: Icons.group,
                            label: 'Zobacz wszystkich użytkowników',
                            onTap: () {},
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                          _ActionButton(
                            icon: Icons.delete,
                            label: 'Usuń firmę',
                            color: Colors.red[50],
                            textColor: Colors.red,
                            onTap: () {},
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Statystyki
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isStatus;
  final bool statusActive;

  const _StatCard({
    super.key,
    required this.title,
    required this.value,
    this.isStatus = false,
    this.statusActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Tokens.gray50,
        borderRadius: BorderRadius.circular(Tokens.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, color: Tokens.textMuted2)),
          SizedBox(height: 4),
          isStatus
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusActive ? Colors.green[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusActive ? Colors.green[700] : Colors.grey[600],
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Tokens.textDark),
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }
}

/// Dolne przyciski
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final EdgeInsets? padding;

  const _ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Tokens.gray50,
        foregroundColor: textColor ?? Tokens.textMuted2,
        padding: padding ?? EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Tokens.radiusLg),
        ),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis)),
    );
  }
}
