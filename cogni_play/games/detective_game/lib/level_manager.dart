// level_manager.dart
// This file manages the game levels, including loading level data from JSON, handling object disappearance logic, and initializing objects in the game world.

import 'object_init.dart';
import 'package:flame/components.dart';
import 'dart:ui' as ui; // Flame uses this for image rendering

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

class LevelData {
  final int id;
  final List<String> objects;
  final int numToDisappear;
  final DisappearType disappearType;

  LevelData({
    required this.id,
    required this.objects,
    required this.numToDisappear,
    required this.disappearType,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      id: json['id'],
      objects: List<String>.from(json['objects']),
      numToDisappear: json['num_to_disappear'],
      disappearType: DisappearType.fromJson(json['disappear_type']),
    );
  }
}

class DisappearType {
  final String type;
  final List<String>? location; 
  final List<String>? hideObjects;

  DisappearType({
    required this.type,
    this.location,
    this.hideObjects,
  });

  factory DisappearType.fromJson(Map<String, dynamic> json) {
    final dynamic locationData = json['location'];

    List<String>? locationList;
    if (locationData != null) {
      if (locationData is List) {
        locationList = List<String>.from(locationData.map((e) => e.toString()));
      } else if (locationData is String) {
        locationList = [locationData];
      }
    }

    return DisappearType(
      type: json['type'],
      location: locationList,
      hideObjects: json['hide_objects'] != null
          ? List<String>.from(json['hide_objects'])
          : null,
    );
  }
}


class ObjectManager {
  List<LevelData> levels = [];
  List<String> currentObjects = [];
  List<String> disappearedObjects = [];
  Map<String, String> objectImages = {}; // Maps object names to image paths
  int currentLevel = 1;


  Future<void> loadLevels(String jsonPath) async {
    try {
      final jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      levels = (jsonData['levels'] as List)
          .map((levelJson) => LevelData.fromJson(levelJson))
          .toList();

      for (var object in levels.expand((level) => level.objects)) {
        objectImages[object] = 'assets/images/Objects/$object.png';
      }
    } catch (e) {
      print('Error loading levels: $e');
    }
  }

  List<String> getType(int levelId) {
    final level = levels.firstWhere((l) => l.id == levelId);
    if (level.disappearType.type == 'location_based') {
      return level.disappearType.location ?? [];
    }
    return [];
  }

  int getNumToDisappear(int levelId) {
    final level = levels.firstWhere((l) => l.id == levelId);
    return level.numToDisappear;
  }




  void loadLevel(int levelId) {
    final level = levels.firstWhere((l) => l.id == levelId);
    currentLevel = levelId;
    currentObjects = List.from(level.objects);
    disappearedObjects = [];

    // Handle different disappearance types
    switch (level.disappearType.type) {
      case 'location_based':
        _handleLocationBasedDisappearance(level);
        break;
      case 'random':
        _handleRandomDisappearance(level);
        break;
      case 'pattern':
        _handlePatternDisappearance(level);
        break;
    }
  }

  void _handleLocationBasedDisappearance(LevelData level) {
    final numToHide = min(level.numToDisappear, level.objects.length);
    disappearedObjects = level.objects.sublist(0, numToHide);

    //currentObjects.removeWhere((obj) => disappearedObjects.contains(obj));
  }

  void _handleRandomDisappearance(LevelData level) {
    final random = Random();
    final availableObjects = level.disappearType.hideObjects ?? level.objects;

    disappearedObjects = List.from(availableObjects)..shuffle(random);
    disappearedObjects = disappearedObjects.sublist(
      0, min(level.numToDisappear, availableObjects.length));

    //currentObjects.removeWhere((obj) => disappearedObjects.contains(obj));
  }

  void _handlePatternDisappearance(LevelData level) {
    if (level.disappearType.hideObjects != null) {
      disappearedObjects = level.disappearType.hideObjects!
          .sublist(0, min(level.disappearType.hideObjects!.length, level.numToDisappear));
    } else {
      _handleRandomDisappearance(level);
    }

   //currentObjects.removeWhere((obj) => disappearedObjects.contains(obj));
  }

  void stealObject(String objectName) {
    if (currentObjects.contains(objectName)) {
      currentObjects.remove(objectName);
      disappearedObjects.add(objectName);
    }
  }

  void reappearObjects(List<String> objectsToReappear) {
    for (var obj in objectsToReappear) {
      if (disappearedObjects.contains(obj)) {
        disappearedObjects.remove(obj);
        currentObjects.add(obj);
      }
    }
  }

  String? getImagePath(String objectName) {
    return objectImages[objectName];
  }

  /// Initializes level objects in random non-overlapping positions
  /// using preloaded Flame-compatible images (ui.Image)
  Future<Map<String, SpriteComponent>> initializeLevelObjects(
  Vector2 screenSize,
  Map<String, ui.Image> loadedImages,
  List<String> disapear_type,
  int num_to_disappear,
  ) async {
    final initializer = ObjectInitializer();
    final List<SpriteComponent> spriteComponents = await initializer.initializeObjects(currentObjects, screenSize, loadedImages, disapear_type, num_to_disappear);
    final Map<String, SpriteComponent> objectMap = {};
    for (int i = 0; i < currentObjects.length; i++) {
      objectMap[currentObjects[i]] = spriteComponents[i];
    }
    return objectMap;
  }
}
