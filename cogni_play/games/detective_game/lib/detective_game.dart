import 'level_manager.dart'; // You already have it set
import 'package:flame/events.dart'; // Required for TapDownInfo
import 'package:flame/components.dart';
import 'package:flutter/services.dart'; // for rootBundle
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // For TextStyle


class DetectiveGame extends FlameGame with TapDetector {
  late ObjectManager objectManager;
  late Map<String, SpriteComponent> levelObjects;
  late Timer countdownTimer;

  late TextComponent countdownText;
  int countdownValue = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    objectManager = ObjectManager();
    await objectManager.loadLevels('assets/level_data.json');
    objectManager.loadLevel(1);

    Map<String, ui.Image> loadedImages = {};

    for (var objectName in objectManager.currentObjects) {
      final imagePath = objectManager.getImagePath(objectName);
      if (imagePath != null) {
        final data = await rootBundle.load(imagePath);
        final codec = await ui.instantiateImageCodec(Uint8List.view(data.buffer));
        final frame = await codec.getNextFrame();
        loadedImages[objectName] = frame.image;
      }
    }

   levelObjects = await objectManager.initializeLevelObjects(size, loadedImages);
    for (var obj in levelObjects.values) {
      add(obj);
    }

    // Initialize countdown text
    countdownText = TextComponent(
      text: '$countdownValue',
      position: Vector2(size.x / 2 - 20, 50),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 48.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(countdownText);

    // Start countdown timer
    countdownTimer = Timer(1.0, repeat: true, onTick: _updateCountdown);
    countdownTimer.start();
    print("Countdown Timer started.");
  }

  void _updateCountdown() {
    countdownValue--;
    print("Countdown value: $countdownValue");

    countdownText.text = '$countdownValue';

    if (countdownValue <= 0) {
      countdownTimer.stop();
      _disappearObjects();
      countdownText.removeFromParent(); // Remove countdown text
    }
  }

  void _disappearObjects() {
    for (int i = 0; i < levelObjects.length; i++) {
      if (objectManager.disappearedObjects.contains(levelObjects.keys.elementAt(i))) {
        final obj = levelObjects.values.elementAt(i);
        obj.removeFromParent(); // Remove the object from the game
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    countdownTimer.update(dt);  // Ensure the countdown timer updates in the game loop
  }

  @override
  void onTapDown(TapDownInfo info) {
    final position = info.eventPosition.global;

    for (int i = 0; i < levelObjects.length; i++) {
      final obj = levelObjects.values.elementAt(i);
      if (obj.toRect().contains(position.toOffset())) {
        if (objectManager.disappearedObjects.contains(levelObjects.keys.elementAt(i))) {
          print('Correct! You found a missing object: ${levelObjects.keys.elementAt(i)}');
        } else {
          print('Oops, that object wasn’t missing.');
        }
      }
    }
  }
}
