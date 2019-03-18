import 'package:flutter/material.dart';

import 'package:native_paint/native_paint.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PainterApp(),
    );
  }
}

class PainterApp extends StatefulWidget {
  @override
  _PainterAppState createState() => _PainterAppState();
}

class _PainterAppState extends State<PainterApp> {
  final PathHistory _paths = PathHistory();
  double topMargin;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    topMargin = mediaQuery.padding.top + kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: mediaQuery.size.width,
            height: (mediaQuery.size.height / 2) - topMargin,
            child: GestureDetector(
              child: ClipRect(
                child: CustomPaint(
                  painter: Painter(_paths),
                ),
              ),
              onPanStart: _start,
              onPanUpdate: _update,
              onPanEnd: _end,
            ),
          ),
          Expanded(child: NativePaintWidget()),
        ],
      ),
    );
  }

  void _start(DragStartDetails details) {
    var position = details.globalPosition;
    _paths.add(Offset(position.dx, position.dy - topMargin));
  }

  void _update(DragUpdateDetails details) {
    var position = details.globalPosition;
    _paths.updateCurrent(Offset(position.dx, position.dy - topMargin));
  }

  void _end(DragEndDetails details) {
    _paths.endCurrent();
  }
}


class Painter extends CustomPainter {
  Painter(this.paths) : super(repaint: paths);

  final PathHistory paths;

  @override
  void paint(Canvas canvas, Size size) {
    paths.draw(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PathHistory extends ChangeNotifier {

  List<MapEntry<Path, Paint>> _paths;
  bool _inDrag;
  var paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round;

  PathHistory() : _paths = [], _inDrag = false;

  void add(Offset startPoint){
    if(!_inDrag) {
      _inDrag = true;
      Path path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(MapEntry(path, paint));
      notifyListeners();
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
      notifyListeners();
    }
  }

  void endCurrent() {
    _inDrag = false;
    if (_paths.length > 1) _checkIntersect();
    notifyListeners();
  }

  void draw(Canvas canvas,Size size){
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        Paint()..color = Colors.blue);
    for(MapEntry<Path, Paint> path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }

  void _checkIntersect() {
    final firstPath = _paths.first.key;
    final lastPath = _paths.last.key;
    /*final lastPathMetrics = lastPath.computeMetrics();
    final firstPathMetrics = firstPath.computeMetrics();
    List<Offset> firstPathPoints = [];
    List<Offset> lastPathPoints = [];
    print('first path metrics length: ${firstPathMetrics.length}');
    print('last path metrics length: ${lastPathMetrics.length}');
    firstPathPoints.addAll(firstPathMetrics.map(
            (metric) => metric.getTangentForOffset(0.0).position).toList());
    lastPathPoints.addAll(lastPathMetrics.map(
            (metric) => metric.getTangentForOffset(0.0).position).toList());
    print('first points: $firstPathPoints');
    print('last points: $lastPathPoints');
    for (var point in lastPathPoints) {
      if (firstPathPoints.firstWhere((firstPathPoint) => firstPathPoint == point, orElse: () => null) != null) {
      _paths.removeLast();
        _paths.add(MapEntry(lastPath, Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round));
        notifyListeners();
      }
    }*/
    Path intersection = Path.combine(
    PathOperation.intersect, firstPath, lastPath);
    if (!intersection.getBounds().isEmpty) {
      if (intersection.computeMetrics().any((metric) => metric.length > 0)) {
        _paths.removeLast();
        _paths.add(MapEntry(lastPath, Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round));
        notifyListeners();
      }
    }
  }
}
