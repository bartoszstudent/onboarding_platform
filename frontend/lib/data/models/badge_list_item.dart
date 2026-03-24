/// Dane jednej odznaki do użycia z [BadgeCard].
///
/// `icon` i `color` są stringami z ustalonego zestawu (jak w projekcie React).
class BadgeListItem {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final bool earned;
  final DateTime? earnedDate;

  const BadgeListItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.earned,
    this.earnedDate,
  });
}
