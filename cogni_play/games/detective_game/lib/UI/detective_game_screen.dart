import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../detective_game.dart';
import 'level_intro_overlay.dart';
import 'pause_overlay.dart';

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
          'LevelIntroOverlay': (_, game) => LevelIntroOverlay(
            levelNumber: game.levelNumber, // Pass the required levelNumber
            onDismiss: () {
              game.overlays.remove('LevelIntroOverlay');
            },
          ),

          'PauseButton': (context, game) => Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.pause, size: 40, color: Colors.white),
              onPressed: () {
                game.pauseEngine();
                game.overlays.remove('PauseButton');
                game.overlays.add('PauseOverlay');
              },
            ),
          ),
          'PauseOverlay': (context, game) => PauseOverlay(
            onResume: () {
              game.resumeEngine();
              game.overlays.remove('PauseOverlay');
              game.overlays.add('PauseButton');
            },
            onRestart: () {
              game.resumeEngine();
              game.overlays.remove('PauseOverlay');
              game.overlays.add('PauseButton');
              game.startLevel(game.levelNumber);
            },
            onQuit: () {
              game.resumeEngine();
              game.overlays.remove('PauseOverlay');
              Navigator.of(context).pop(); // Or navigate to your home screen
              Navigator.of(context).pop();
            },
          ),

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
        initialActiveOverlays: const ['PauseButton'], // Start with button visible
      ),
    );
  }
}
