import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../detective_game.dart';
import 'level_intro_overlay.dart';
import 'pause_overlay.dart';
import 'package:google_fonts/google_fonts.dart';

class DetectiveGameScreen extends StatelessWidget {
  const DetectiveGameScreen({super.key});

  // this is the main screen for the game and handles all the overlays and some game logic
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
              game.startCountdown();
            },
          ),
          'PauseButton': (context, game) => Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF9633E), // Set desired background color
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.pause, size: 70, color: Colors.white),
                  onPressed: () {
                    game.pauseEngine();
                    game.overlays.remove('PauseButton');
                    game.overlays.add('PauseOverlay');
                  },
                ),
              ),
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
              Navigator.of(context).pop(); 
              Navigator.of(context).pop();
            },
          ),

          'CheckButton': (BuildContext context, DetectiveGame game) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    game.checkAnswers();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 70),
                    backgroundColor: const Color(0xFF8C52FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withValues(alpha:0.4),
                  ),
                  child: Text(
                    'Check Answers',
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      height: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },

        },
        initialActiveOverlays: const ['PauseButton'], 
      ),
    );
  }
}
