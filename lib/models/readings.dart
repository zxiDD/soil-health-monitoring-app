class Reading {
  final DateTime timestamp;
  final double temperature;
  final double moisture;

  Reading({
    required this.timestamp,
    required this.temperature,
    required this.moisture,
  });

  Map<String, dynamic> toMap() => {
        "timestamp": timestamp.toIso8601String(),
        "temperature": temperature,
        "moisture": moisture,
      };

  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      timestamp: DateTime.parse(map["timestamp"] as String),
      temperature: (map["temperature"] as num).toDouble(),
      moisture: (map["moisture"] as num).toDouble(),
    );
  }
}
