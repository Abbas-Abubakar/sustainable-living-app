class CarbonFootprint {
  final String userId;
  final double transport; // e.g., emissions from driving
  final double energy;    // home electricity usage
  final double food;      // meat, dairy, etc.
  final DateTime date;
  final String period;    // 'daily', 'weekly', 'monthly'

  double get total => transport + energy + food;

  CarbonFootprint({
    required this.userId,
    required this.transport,
    required this.energy,
    required this.food,
    required this.date,
    required this.period,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'transport': transport,
      'energy': energy,
      'food': food,
      'total': total,
      'date': date.toIso8601String(),
      'period': period,
    };
  }

  factory CarbonFootprint.fromMap(Map<String, dynamic> map) {
    return CarbonFootprint(
      userId: map['userId'],
      transport: (map['transport'] as num).toDouble(),
      energy: (map['energy'] as num).toDouble(),
      food: (map['food'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      period: map['period'] ?? 'daily', // fallback to 'daily' if not present
    );
  }
}
