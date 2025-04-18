import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../detective_game.dart';

class DetectiveGameScreen extends StatelessWidget {
  const DetectiveGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: DetectiveGame(),
      ),
    );
  }
}
