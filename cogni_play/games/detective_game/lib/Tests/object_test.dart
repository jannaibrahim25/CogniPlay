import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import 'package:cogni_play/object_behavior.dart';
import 'package:cogni_play/object_init.dart';


// import 'package:cogni_play/lib/object_init.dart';
// import 'package:cogni_play/level_manager.dart';
// import 'package:cogni_play/object_behavior.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ObjectInitializer', () {
    late ObjectInitializer initializer;
    late Vector2 screenSize;
    late Map<String, ui.Image> loadedImages;

    setUp(() async {
      initializer = ObjectInitializer();
      screenSize = Vector2(800, 600);

      // Simulate loading dummy images
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawRect(Rect.fromLTWH(0, 0, 100, 100), Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(100, 100);

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final flameImage = await decodeImageFromList(bytes);


      loadedImages = {
        'apple': flameImage,
        'banana': flameImage,
        'cherry': flameImage,
      };
    });

    test('initializes non-overlapping objects', () {
      final objects = initializer.initializeObjects(
        ['apple', 'banana', 'cherry'],
        screenSize,
        loadedImages,
      );

      expect(objects.length, 3);
      // Check that no two objects are at the same position
      for (int i = 0; i < objects.length; i++) {
        for (int j = i + 1; j < objects.length; j++) {
          final dist = objects[i].position.distanceTo(objects[j].position);
          expect(dist, greaterThan(50)); // 100px object size → 50px radius
        }
      }
    });
  });

  group('ObjectBehavior', () {
    late ObjectBehavior behavior;
    late SpriteComponent testObject;

    setUp(() {
      behavior = ObjectBehavior(reappearDelay: 1.0);
      testObject = SpriteComponent()
        ..size = Vector2(100, 100)
        ..position = Vector2(50, 50)
        ..opacity = 1.0;
    });

    test('handleTap adds bounce effect', () {
      behavior.handleTap(testObject);

      expect(testObject.children.length, greaterThan(0));
      expect(
        testObject.children.firstWhere((c) => c is SequenceEffect),
        isNotNull,
      );
    });

    test('_makeObjectDisappear sets opacity to 0', () {
      behavior.makeObjectDisappear(testObject);
      expect(testObject.opacity, equals(0.0));
    });

    test('makeObjectReappear sets opacity to 100', () {
      behavior.makeObjectReappear(testObject);
      expect(testObject.opacity, equals(100.0));
    });

    test('scheduleReappear adds TimerComponent', () {
      behavior.scheduleReappear(testObject);
      expect(
        testObject.children.any((child) => child is TimerComponent),
        isTrue,
      );
    });
  });
}
