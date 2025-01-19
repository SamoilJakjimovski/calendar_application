import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exam_schedule.dart';
import '../providers/exam_provider.dart';

class ExamDetailScreen extends StatefulWidget {
  final ExamSchedule? exam;
  ExamDetailScreen({this.exam});

  @override
  _ExamDetailScreenState createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late DateTime _dateTime;
  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();
    _title = widget.exam?.title ?? '';
    _dateTime = widget.exam?.dateTime ?? DateTime.now();
    _latitude = widget.exam?.latitude ?? 0.0;
    _longitude = widget.exam?.longitude ?? 0.0;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newExam = ExamSchedule(
        title: _title,
        dateTime: _dateTime,
        latitude: _latitude,
        longitude: _longitude,
      );
      Provider.of<ExamProvider>(context, listen: false).addExam(newExam);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam != null ? 'Edit Exam' : 'Add Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Exam Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a title' : null,
                onSaved: (value) => _title = value ?? '',
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Date & Time'),
                subtitle: Text(
                  '${_dateTime.toLocal()}'.split(' ')[0] +
                      ' ' +
                      TimeOfDay.fromDateTime(_dateTime).format(context),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _latitude.toString(),
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (value) => _latitude = double.parse(value!),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _longitude.toString(),
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (value) => _longitude = double.parse(value!),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
