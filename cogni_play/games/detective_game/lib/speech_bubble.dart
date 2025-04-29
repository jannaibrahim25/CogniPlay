import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SpeechBubbleComponent extends PositionComponent {
  final String message;
  late SpriteComponent character;
  late TextComponent speechText;

  SpeechBubbleComponent({
    required this.message,
    required Sprite characterSprite,
    required Vector2 screenSize,
  }) {
    size = Vector2(screenSize.x, 150); // Height of bubble area
    position = Vector2(0, screenSize.y - 200); // Near bottom

    character = SpriteComponent(
      sprite: characterSprite,
      size: Vector2(100, 100),
      position: Vector2(30, 30),
    );

    speechText = TextComponent(
      text: message,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(140, 60),
    );

    addAll([character, speechText]);
  }
}
