//starter file for the theif eventully we will add in annimations

import 'package:flame/components.dart';

class ThiefComponent extends SpriteComponent {
  ThiefComponent({
    required Sprite sprite,
    required Vector2 startPosition,
  }) : super(
    sprite: sprite,
    size: Vector2(80, 80),
    position: startPosition,
    priority: 1,
  );
}
