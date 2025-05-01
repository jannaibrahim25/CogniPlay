// pause_overlay.dart
import 'package:flutter/material.dart';

class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onQuit;


  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onQuit,
  });
  
  //pause button on the screen. It is located in the top left of the game screen
  @override
  Widget build(BuildContext context) {
    final ButtonStyle pauseButtonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(200, 60),
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: Color(0xFFFFF3F0),
    );
    return Center(
      child: Card(
        color: Colors.white.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 30,
            left: 40,
            right: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Paused',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onResume,
                style: pauseButtonStyle,
                child: Text(
                  'Resume',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFF9633E),
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRestart,
                style: pauseButtonStyle,
                child: Text(
                  'Restart Level',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFF9633E),
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onQuit,
                style: pauseButtonStyle,
                child: Text(
                  'Quit to Home',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFF9633E),
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
