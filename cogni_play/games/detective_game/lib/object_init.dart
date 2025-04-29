//object_init.dart
// This file contains the ObjectInitializer class, which is responsible for initializing game objects with non-overlapping positions and adding them to the game world. It also includes methods for checking if two circles overlap and finding a non-overlapping position for new objects.
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'UI/sprite.dart';

class ObjectInitializer {
  final List<CircleHitbox> _occupiedAreas = [];
  final Vector2 _objectSize = Vector2(100, 100);
  final double _margin = 30;

  List<SpriteComponent> initializeObjects(
  List<String> objectNames,
  Vector2 screenSize,
  Map<String, Image> loadedImages,
  List<String> disappearType,
  int numToDisappear,
) {
  _occupiedAreas.clear();
  final objects = <SpriteComponent>[];

  int targetedObjectsPlaced = 0;
  int disapearLocations = disappearType.length;

  for (final name in objectNames) {
    Vector2 position;

    if (targetedObjectsPlaced < numToDisappear) { 
      // Place objects in specified area when removing objects based off of location
      if (targetedObjectsPlaced >= disapearLocations) {
        position = _findPositionInRegion(screenSize, disappearType.elementAt(disapearLocations - 1));
      } else {
        position = _findPositionInRegion(screenSize, disappearType.elementAt(targetedObjectsPlaced));
      }
      targetedObjectsPlaced++;

    } else {
      // Place objects randomly outside the specified region
      position = _findNonOverlappingPosition(screenSize, disappearType);
    }

    final image = loadedImages[name];
    if (image == null) {
      print('Warning: Image not found for $name');
      continue;
    }
    final sprite = Sprite(image);

    //create custom sprite
    final component = CustomSprite(
      sprite: sprite,
      position: position,
      size: _objectSize,
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

  // Finds a random position in the specified region of the screen
  Vector2 _findPositionInRegion(Vector2 screenSize, String region) {
  final random = Random();
  final double halfWidth = screenSize.x / 2;
  final double halfHeight = screenSize.y / 2;

  for (var i = 0; i < 100; i++) {
    double x, y;
    switch (region) {
      case 'top_left':
        x = _margin + random.nextDouble() * (halfWidth - _objectSize.x - 2 * _margin);
        y = _margin + random.nextDouble() * (halfHeight - _objectSize.y - 2 * _margin);
        break;
      case 'top_right':
        x = halfWidth + random.nextDouble() * (halfWidth - _objectSize.x - 2 * _margin);
        y = _margin + random.nextDouble() * (halfHeight - _objectSize.y - 2 * _margin);
        break;
      case 'bottom_left':
        x = _margin + random.nextDouble() * (halfWidth - _objectSize.x - 2 * _margin);
        y = halfHeight + random.nextDouble() * (halfHeight - _objectSize.y - 2 * _margin);
        break;
      case 'bottom_right':
        x = halfWidth + random.nextDouble() * (halfWidth - _objectSize.x - 2 * _margin);
        y = halfHeight + random.nextDouble() * (halfHeight - _objectSize.y - 2 * _margin);
        break;
      default:
        throw Exception('Unknown region: $region');
    }
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
  throw Exception('Could not find non-overlapping position in $region');
}



  // Finds a random position on the screen that does not overlap with existing objects
  // makes sure not to place objects that won't be removed in the area of the screen that will have objects removed from
  // ex: if we are removing from the red_car from the top_left of the screen this function prevents any other object from
  // being placed in the top_left of the screen
  Vector2 _findNonOverlappingPosition(Vector2 screenSize, List<String> forbiddenRegions) {
  final random = Random();
  final double halfWidth = screenSize.x / 2;
  final double halfHeight = screenSize.y / 2;

  for (var i = 0; i < 100; i++) {
    final x = _margin + random.nextDouble() * (screenSize.x - _objectSize.x - 2 * _margin);
    final y = _margin + random.nextDouble() * (screenSize.y - _objectSize.y - 2 * _margin);

    bool inForbidden = false;
    for (final region in forbiddenRegions) {
      switch (region) {
        case 'top_left':
          if (x < halfWidth && y < halfHeight) inForbidden = true;
          break;
        case 'top_right':
          if (x >= halfWidth && y < halfHeight) inForbidden = true;
          break;
        case 'bottom_left':
          if (x < halfWidth && y >= halfHeight) inForbidden = true;
          break;
        case 'bottom_right':
          if (x >= halfWidth && y >= halfHeight) inForbidden = true;
          break;
      }
      if (inForbidden) break; // No need to keep checking once inside forbidden
    }
    if (inForbidden) continue; // Try a new random point

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
