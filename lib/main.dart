import 'package:assets_audio_player_seekbar/seekbar_demo.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seekbar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SeekbarDemo(),
    );
  }
}