import 'package:calendar_application/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exam_provider.dart';
import 'screens/home_screen.dart';
import 'screens/exam_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamProvider(),
      child: MaterialApp(
        title: 'Exam Scheduler',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          }

          if (settings.name == '/examDetail') {
            return MaterialPageRoute(builder: (context) => ExamDetailScreen());
          }

          if (settings.name == '/map') {
            // Extract the arguments
            final args = settings.arguments as Map<String, dynamic>?;
            final selectedDate =
                args?['selectedDate'] as DateTime? ?? DateTime.now();

            return MaterialPageRoute(
              builder: (context) => MapScreen(selectedDate: selectedDate),
            );
          }

          return null;
        },
      ),
    );
  }
}
