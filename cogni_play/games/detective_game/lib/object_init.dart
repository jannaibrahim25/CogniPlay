
//object_init.dart
// This file contains the ObjectInitializer class, which is responsible for initializing game objects with non-overlapping positions and adding them to the game world. It also includes methods for checking if two circles overlap and finding a non-overlapping position for new objects.
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';

class ObjectInitializer {
  final List<CircleHitbox> _occupiedAreas = [];
  final Vector2 _objectSize = Vector2(100, 100);
  final double _margin = 30;

  List<SpriteComponent> initializeObjects(
    List<String> objectNames,
    Vector2 screenSize,
    Map<String, Image> loadedImages, // Map of 'apple' -> Image etc.
  ) {
    _occupiedAreas.clear();
    final objects = <SpriteComponent>[];

    for (final name in objectNames) {
      final position = _findNonOverlappingPosition(screenSize);

      final image = loadedImages[name];
      if (image == null) {
        print('Warning: Image not found for $name');
        continue;
      }

      final sprite = Sprite(image);

      final component = SpriteComponent(
        sprite: sprite,
        position: position,
        size: _objectSize,
        anchor: Anchor.center,
      )..add(CircleHitbox());

      objects.add(component);

      _occupiedAreas.add(CircleHitbox(
        position: position,
        radius: _objectSize.x / 2,
        isSolid: true,
        anchor: Anchor.center,
        collisionType: CollisionType.passive,
      ));
    }

    return objects;
  }

  Vector2 _findNonOverlappingPosition(Vector2 screenSize) {
    final random = Random();
    for (var i = 0; i < 100; i++) {
      final x = _margin + random.nextDouble() * (screenSize.x - _objectSize.x - 2 * _margin);
      final y = _margin + random.nextDouble() * (screenSize.y - _objectSize.y - 2 * _margin);
      final testArea = CircleHitbox(
        position: Vector2(x, y),
        radius: _objectSize.x / 2,
        isSolid: true,
        anchor: Anchor.center,
      );

      if (!_occupiedAreas.any((area) => areCirclesOverlapping(area, testArea))) {
        return Vector2(x, y);
      }
    }
    throw Exception('Could not find non-overlapping position');
  }

  bool areCirclesOverlapping(CircleHitbox a, CircleHitbox b) {
    final centerA = a.absoluteCenter;
    final centerB = b.absoluteCenter;

    final radiusA = a.radius * a.absoluteScale.x;
    final radiusB = b.radius * b.absoluteScale.x;

    return centerA.distanceTo(centerB) < (radiusA + radiusB);
  }
}
