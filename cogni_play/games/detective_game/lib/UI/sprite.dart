import 'package:flame/components.dart';
import 'package:flutter/material.dart';

//class for making and loading a custom sprite basically a circle with a sprite inside
class CustomSprite extends SpriteComponent {
  final Sprite sprite;

  CustomSprite({
    required this.sprite,
    required Vector2 position,
    required Vector2 size,
  }) : 
  super(
    position: position,
    size: size,
    anchor: Anchor.center,
    );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final circle = CircleComponent(
      radius: size.x * 0.7,
      paint: Paint()
        ..color = Colors.white.withValues(alpha: 0.5) // white circle slighly bigger than the sprite. Non transparent right now but might change
        ..style = PaintingStyle.fill,
      anchor: Anchor.center,
      position: size / 2,
      priority: 0,
    );

    final spriteComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.center,
      position: size / 2,
      priority: 1,
    );

    add(circle);
    add(spriteComponent); //creating the custom sprite
  }
}
