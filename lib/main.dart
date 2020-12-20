import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pi estimation counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Offset> pointsList = [];
  Random random = new Random();
  double side = 100;
  double pi_estimate = -1;

  void _incrementCounter() {
    print("Side is $side");
    setState(() {
      _counter++;
      pointsList.add(Offset(random.nextInt(side.toInt()).toDouble(),
          random.nextInt(side.toInt()).toDouble()));
    });
    estimate();
  }

  void estimate() {
    int inside = 0, outside = 0;
    double r = side / 2;
    for (Offset o in pointsList) {
      if ((o.dx - r) * (o.dx - r) + (o.dy - r) * (o.dy - r) - r * r > 1) {
        outside++;
      } else {
        inside++;
      }
    }
    pi_estimate = 4 * inside / _counter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            LayoutBuilder(
              builder: (_, constraints) {
                side = constraints.widthConstraints().maxWidth;
                return Container(
                  width: constraints.widthConstraints().maxWidth,
                  height: constraints.widthConstraints().maxWidth,
                  color: Colors.yellowAccent,
                  child: CustomPaint(
                    painter: OpenPainter(side, pointsList),
                  ),
                );
              },
            ),
            pi_estimate == -1
                ? Text("Start counting to estimate Pi experimentally")
                : Text("Estimated value of Pi is $pi_estimate")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  double side;
  List<Offset> pointsList;
  OpenPainter(this.side, this.pointsList);
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    var paint2 = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;
    //a rectangle
    canvas.drawCircle(Offset(side / 2, side / 2), side / 2, paint1);
    if (pointsList.isNotEmpty)
      for (Offset points in pointsList) canvas.drawCircle(points, 2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PredictionPoint {
  int x, y;
  PredictionPoint(this.x, this.y);
}
