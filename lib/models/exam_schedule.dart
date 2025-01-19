class ExamSchedule {
  final String title;
  final DateTime dateTime;
  final double latitude;
  final double longitude;

  ExamSchedule({
    required this.title,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
  });

  DateTime get date => DateTime(dateTime.year, dateTime.month, dateTime.day);
}
