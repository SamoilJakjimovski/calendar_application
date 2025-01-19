class ExamEvent {
  final String id;
  final String title;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  ExamEvent({
    String? id,
    required this.title,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ExamEvent.fromJson(Map<String, dynamic> json) {
    return ExamEvent(
      id: json['id'],
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
