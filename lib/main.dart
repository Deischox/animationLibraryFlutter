import 'package:animation/testnewar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import "dart:async";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;
  Vector3 position = Vector3(0, 0, 0);
  late Scene _scene;
  late Object arrow;
  late AnimationController _controller;
  late Timer mytimer;

  void StartTimer() {
    mytimer = Timer.periodic(Duration(milliseconds: 15), (timer) {
      _counter -= 1;
      arrow.rotation.y = _counter;
      arrow.updateTransform();
      _scene.update();
    });
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _scene.camera.position.z = 10;
    arrow = Object(fileName: "assets/turn_arrow/arrow.obj", position: Vector3(0, 1, 0));
    Object coffee = Object(fileName: "assets/coffee_cup/coffee.obj", position: position);
    _scene.world.add(coffee);
    _scene.world.add(arrow);
  }

  void changeArrow() {
    _scene.world.remove(arrow);
    arrow = Object(fileName: "assets/arrow/model.obj", position: Vector3(0, 1, 0));
    _scene.world.add(arrow);
    mytimer.cancel();
    mytimer = Timer.periodic(Duration(milliseconds: 15), (timer) {
      _counter += 0.02;
      arrow.position.y = 1 + _counter % 2;
      arrow.updateTransform();
      _scene.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    StartTimer();
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Cube(onSceneCreated: _onSceneCreated),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ObjectsOnPlanesWidget()),
                ),
                child: Text("AR"),
              ),
            ),
            ElevatedButton(onPressed: changeArrow, child: Text("Next Step"))
          ],
        ));
  }
}
