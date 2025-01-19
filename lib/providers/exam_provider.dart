// lib/providers/exam_provider.dart
import 'package:flutter/material.dart';
import '../models/exam_schedule.dart';

class ExamProvider extends ChangeNotifier {
  final List<ExamSchedule> _exams = [];

  List<ExamSchedule> get exams => _exams;

  void addExam(ExamSchedule exam) {
    _exams.add(exam);
    notifyListeners();
  }

  List<ExamSchedule> getExamsForDate(DateTime date) {
    return _exams.where((exam) {
      return exam.date.year == date.year &&
          exam.date.month == date.month &&
          exam.date.day == date.day;
    }).toList();
  }
}
