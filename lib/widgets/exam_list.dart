import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';

class ExamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final exams = context.watch<ExamProvider>().exams;

    return ListView.builder(
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return ListTile(
          title: Text(exam.title),
          subtitle: Text(
              '${exam.dateTime}\nCoordinates: (${exam.latitude}, ${exam.longitude})'),
          onTap: () {
            Navigator.pushNamed(context, '/examDetail', arguments: exam);
          },
        );
      },
    );
  }
}
