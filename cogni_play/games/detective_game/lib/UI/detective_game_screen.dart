import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../detective_game.dart';

class DetectiveGameScreen extends StatelessWidget {
  const DetectiveGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<DetectiveGame>(
        game: DetectiveGame(),

        //check answers overlay button
        // Will be adding a pause button and restart button later
        overlayBuilderMap: {
          'CheckButton': (BuildContext context, DetectiveGame game) {
            return Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 75, //side of button
              child: ElevatedButton(
                onPressed: () {
                  game.checkAnswers(); //check answers function declared in Detective_game.dart
                },
                child: const Text('Check Answers'),
              ),
            );
          },
        },
      ),
    );
  }
}
