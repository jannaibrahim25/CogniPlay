
// object_behavior.dart
// This file contains the ObjectBehavior class, which is responsible for managing the behavior of game objects. It includes methods for making objects disappear and reappear, handling tap events, and managing the stealing probability of objects.

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class ObjectBehavior {
 // final double stealProbability;
  final double reappearDelay;

  ObjectBehavior({
    // this.stealProbability = 0.3,
    this.reappearDelay = 5.0,
  });

  // void handleStealing(List<SpriteComponent> objects) {
  //   for (final obj in objects) {
  //     if (obj.opacity > 0.0 && Random().nextDouble() < stealProbability) {
  //       _makeObjectDisappear(obj);
  //     }
  //   }
  // }

  void makeObjectDisappear(SpriteComponent object) {
    object.opacity = 0.0;
  }

  void scheduleReappear(SpriteComponent object) {
    object.add(TimerComponent(
      period: reappearDelay,
      removeOnFinish: true,
      onTick: () => makeObjectReappear(object),
    ));
  }

  void makeObjectReappear(SpriteComponent object) {
    object.opacity = 100.0;

  }

  void handleTap(SpriteComponent object) {
    if (object.opacity > 0.0) {
      object.add(SequenceEffect(
        [
          ScaleEffect.by(Vector2.all(1.2), EffectController(duration: 0.1)),
          ScaleEffect.by(Vector2.all(1/1.2), EffectController(duration: 0.1)),
        ],
      ));
    }
  }
}