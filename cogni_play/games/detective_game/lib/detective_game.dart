import 'level_manager.dart'; 
import 'package:flame/events.dart'; 
import 'package:flame/components.dart';
import 'package:flutter/services.dart'; 
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class DetectiveGame extends FlameGame with TapDetector {
  late ObjectManager objectManager;
  late Map<String, SpriteComponent> levelObjects;
  late Timer countdownTimer;
  late TextComponent countdownText;
  late TextComponent gameText;
  late SpriteComponent background;

  //Variables for game and level managment
  int countdownValue = 5;
  int levelNumber = 1; 
  bool allowGuessing = false;
  List<Vector2> selectedPositions = [];
  final double guessRadius = 90; //size of guess square

  //Starts the level and clears all previous level objects
  Future<void> startLevel(int levelNumber) async {
  overlays.remove('CheckButton'); 
  allowGuessing = false;
  selectedPositions.clear();
  children.clear();
  this.levelNumber = levelNumber;
  objectManager.loadLevel(levelNumber);
  overlays.add('LevelIntroOverlay');

  

  // Load and add background
  final backgroundImage = await images.load('ocean_level.jpg'); //ocean background for every level right now
  background = SpriteComponent(
    sprite: Sprite(backgroundImage),
    size: size,
    position: Vector2.zero(),
    priority: -1,
  );
  add(background);


  // load the objects and map the name to created sprites
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
  levelObjects = await objectManager.initializeLevelObjects(
    size,
    loadedImages,
    objectManager.getType(levelNumber),
    objectManager.getNumToDisappear(levelNumber),
  );

  // Add the objects to the game
  for (var obj in levelObjects.values) {
    add(obj);
  }

  // countdown timer (this will be changed 5 seconds is super short)
  //UI for will change to add more information (Connor)


  countdownValue = 22; // The countdown time is 15 seconds after the level intro overlay dissapears
  countdownText = TextComponent(
    text: '$countdownValue',
    position: Vector2(size.x / 2 - 20, 60),
    textRenderer: TextPaint(
      style: GoogleFonts.luckiestGuy(
        fontSize: 72,
        letterSpacing: 8,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  add(countdownText);
  countdownTimer = Timer(1.0, repeat: true, onTick: _updateCountdown);
  countdownTimer.start();
  overlays.add("PauseButton");
}

  //Updating the countdown timer
  void _updateCountdown() {
    final textPaint = TextPaint(
    style: GoogleFonts.luckiestGuy(
      fontSize: 56,
      shadows: [
        Shadow(
          blurRadius: 5,
          color: Colors.black,
          offset: const Offset(2, 2),
        ),
      ],
      color: Colors.white,
      ),
  );
    // Create the TextComponent
    final gameText = TextComponent(
      text: 'Find the missing objects!',
      textRenderer: textPaint,
    );
    // Optionally set anchor to center
    gameText.anchor = Anchor.topCenter;
    // Position in the horizontal center
    gameText.position = Vector2(size.x / 2, 60);
    // Add it to your game
    countdownValue--;
    print("Countdown value: $countdownValue");
    countdownText.text = '$countdownValue';
    if (countdownValue <= 0) {
      countdownTimer.stop();
      _disappearObjects();
      countdownText.removeFromParent(); 
      add(gameText);
    }
  }

  //removes objects from the game once the time runs out and allows the user to start guessing
  // I didn't use the method from level_manager.dart so maybe we can use that or just remove it
  void _disappearObjects() {
  for (int i = 0; i < levelObjects.length; i++) {
    if (objectManager.disappearedObjects.contains(levelObjects.keys.elementAt(i))) {
      final obj = levelObjects.values.elementAt(i);
      obj.removeFromParent(); // Remove the object from the game
    }
  }
    allowGuessing = true; // Enable guessing
    overlays.add("CheckButton");
  }


  // onLoad method to start the game and read in the level data 
  // Only called for the first level
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    objectManager = ObjectManager();
    await objectManager.loadLevels('assets/level_data.json'); //in level_manager.dart
    await startLevel(1);
  }



  // UI for completed game screen
  // Updated styling to match the theme of the game
  void _showGameCompleteDialog() {
  showDialog(
    context: buildContext!,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(
          'Congratulations!',
          style: GoogleFonts.quicksand(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You have completed all levels!',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFDB825),
              padding: EdgeInsets.only(top:10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35), 
              ),
            ),
            onPressed: () {
              Navigator.of(buildContext!).pop();
              Navigator.of(buildContext!).pop();
              Navigator.of(buildContext!).pop();
            },
            child: Center(
              child: Text(
                'Back to Home',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // we can call this method to start every new level. 
  // Right now there is no way to start from a saved level so we might need to work on that
  void _loadNextLevel() {
  levelNumber++;
  if (levelNumber > objectManager.levels.length) {
    _showGameCompleteDialog();
    return;
  }
  startLevel(levelNumber);
}

  //UI to show the level complete after you get all the guess correctly
  // Finished UI for the level compelete screen
  void _showLevelCompleteDialog() {
  showDialog(
    context: buildContext!,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(
          'Level Complete!',
          style: GoogleFonts.quicksand(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'You found all the missing objects! Ready for next level?',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFDB825),
              padding: EdgeInsets.only(top:10), // Remove internal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35), // Rounded pill shape
              ),
            ),
            onPressed: () {
              Navigator.of(buildContext!).pop();
              _loadNextLevel();
            },
            child: Center(
              child: Text(
                'Next Level',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


//update the countdown timer
@override
  void update(double dt) {
    super.update(dt);
    countdownTimer.update(dt); 
  }


  //handle user guesses
  @override
  void onTapDown(TapDownInfo info) {
  if (!allowGuessing) return;
  final position = info.eventPosition.global;
  // Check if user tapped near an already selected guess
  Vector2? guessToRemove;
  for (var guess in selectedPositions) {
    if (guess.distanceTo(position) <= guessRadius) {
      guessToRemove = guess;
      break;
    }
  }
  if (guessToRemove != null) {
    selectedPositions.remove(guessToRemove); // Deselect if near an existing guess
    print('Deselected a guess at ${guessToRemove.toString()}');
  } else {
    // add a new guess if not full
    if (selectedPositions.length < objectManager.disappearedObjects.length) {
      selectedPositions.add(position);
      print('Selected new guess at ${position.toString()}');
    }
  }
}

  //draw the guess on the screen
  @override
void render(Canvas canvas) {
  super.render(canvas);
  for (var pos in selectedPositions) {
    final center = pos.toOffset();

    // Outer glow
    final glowPaint = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, guessRadius * 0.7, glowPaint);


    // Bubble outline
    final outlinePaint = Paint()
      ..color = Colors.yellowAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, guessRadius * 0.7, outlinePaint);
  }
}



  // Public method called by check answers overlay button
  // This method checks the selected guesses against the disappeared objects
  void checkAnswers() {
    List<Vector2> incorrectGuesses = [];
    if (selectedPositions.length != objectManager.disappearedObjects.length) {
      _showResultDialog('Please select ${objectManager.disappearedObjects.length} guesses!');
      return;
    }
    int correctGuesses = 0;
    final missingObjects = objectManager.disappearedObjects;
    for (var guess in selectedPositions) {
      bool foundMatch = false;
      for (var objectName in missingObjects) {
        final obj = levelObjects[objectName];
        if (obj == null) continue;

        final objCenter = obj.position;
        final distance = guess.distanceTo(objCenter);

        if (distance <= guessRadius) {
          foundMatch = true;
          break;
        }
      }
      if (foundMatch) {
        correctGuesses++;
      } else {
        incorrectGuesses.add(guess);
      }
    }
    if (correctGuesses == missingObjects.length) {
      _showLevelCompleteDialog(); 
    } else {
      _showResultDialog('Incorrect. You found $correctGuesses out of ${missingObjects.length} correctly.');
      int l = incorrectGuesses.length;
      for (int i = 0; i < l; i++) {
        print(i);
        selectedPositions.remove(incorrectGuesses[i]); // Remove incorrect guess
      }
    }
  }

  // Show the results from the guesses 
  // shows how many you got correct
  // finished UI for the result screen
  void _showResultDialog(String message) {
    showDialog(
      context: buildContext!,
      builder: (_) => AlertDialog(
        title: Text(
          'Result',
          style: GoogleFonts.quicksand(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.quicksand(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFDB825),
              padding: EdgeInsets.only(top:10), // Remove internal padding
              shape: const CircleBorder(),
              fixedSize: const Size(70, 70), // Force it to be a circle
            ),
            onPressed: () {
              Navigator.of(buildContext!).pop();
            },
            child: Center(
              child: Text(
                'OK',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
