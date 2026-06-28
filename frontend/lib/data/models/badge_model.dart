enum BadgeRarity { common, rare, epic, legendary }

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String category;
  final BadgeRarity rarity;
  final int xpReward;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.rarity,
    required this.xpReward,
  });

  String get emoji {
    switch (icon) {
      case 'zap':
        return '⚡';
      case 'medal':
        return '🏅';
      case 'trophy':
        return '🏆';
      case 'target':
        return '🎯';
      case 'star':
        return '⭐';
      case 'flame':
        return '🔥';
      case 'crown':
        return '👑';
      default:
        return icon;
    }
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: json['category'] as String,
      rarity: BadgeRarity.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => BadgeRarity.common,
      ),
      xpReward: (json['xpReward'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'category': category,
      'rarity': rarity.name,
      'xpReward': xpReward,
    };
  }
}

class EmployeeModel {
  final String id;
  final String name;
  final String role;
  final String department;
  final List<String> badges;
  final String? avatar;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.badges,
    this.avatar,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      department: json['department'] as String,
      badges: List<String>.from(json['badges'] as List),
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'department': department,
      'badges': badges,
      'avatar': avatar,
    };
  }
}
