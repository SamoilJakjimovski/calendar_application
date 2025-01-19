import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import '../models/exam_schedule.dart';
import 'dart:math' show sqrt, pow;

class MapScreen extends StatefulWidget {
  final DateTime selectedDate;

  const MapScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng _startPosition = const LatLng(41.98, 21.43);
  ExamSchedule? _nearestExam;
  List<ExamSchedule> _todaysExams = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    _filterTodaysExams();
    _addMarkers();
    _findAndDrawRouteToNearestExam();
  }

  void _filterTodaysExams() {
    final allExams = Provider.of<ExamProvider>(context, listen: false).exams;
    _todaysExams = allExams.where((exam) {
      return exam.dateTime.year == widget.selectedDate.year &&
          exam.dateTime.month == widget.selectedDate.month &&
          exam.dateTime.day == widget.selectedDate.day;
    }).toList();
  }

  void _addMarkers() {
    setState(() {
      _markers.clear();

      // Start position marker
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: _startPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Start Position'),
      ));

      // Exam markers for today's exams only
      for (var exam in _todaysExams) {
        _markers.add(Marker(
          markerId: MarkerId(exam.title),
          position: LatLng(exam.latitude, exam.longitude),
          infoWindow: InfoWindow(
            title: exam.title,
            snippet:
                '${exam.dateTime.hour}:${exam.dateTime.minute.toString().padLeft(2, '0')}',
          ),
        ));
      }
    });
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    return sqrt(pow(point1.latitude - point2.latitude, 2) +
        pow(point1.longitude - point2.longitude, 2));
  }

  void _findAndDrawRouteToNearestExam() {
    if (_todaysExams.isEmpty) {
      setState(() {
        _nearestExam = null;
        _polylines.clear();
      });
      return;
    }

    // Find nearest exam
    ExamSchedule nearest = _todaysExams.reduce((curr, next) {
      double currDist = _calculateDistance(
          _startPosition, LatLng(curr.latitude, curr.longitude));
      double nextDist = _calculateDistance(
          _startPosition, LatLng(next.latitude, next.longitude));
      return currDist < nextDist ? curr : next;
    });

    setState(() {
      _nearestExam = nearest;
      _drawRoute(nearest);
    });
  }

  void _drawRoute(ExamSchedule exam) {
    final examLocation = LatLng(exam.latitude, exam.longitude);

    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: [_startPosition, examLocation],
        color: Colors.blue,
        width: 5,
      ));

      // Adjust map bounds to show route
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _startPosition.latitude < examLocation.latitude
              ? _startPosition.latitude
              : examLocation.latitude,
          _startPosition.longitude < examLocation.longitude
              ? _startPosition.longitude
              : examLocation.longitude,
        ),
        northeast: LatLng(
          _startPosition.latitude > examLocation.latitude
              ? _startPosition.latitude
              : examLocation.latitude,
          _startPosition.longitude > examLocation.longitude
              ? _startPosition.longitude
              : examLocation.longitude,
        ),
      );

      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text(_nearestExam != null
            ? 'Route to: ${_nearestExam!.title}'
            : 'No Exams on $dateStr'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Exams for $dateStr: ${_todaysExams.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _startPosition,
                zoom: 12,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findAndDrawRouteToNearestExam,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
