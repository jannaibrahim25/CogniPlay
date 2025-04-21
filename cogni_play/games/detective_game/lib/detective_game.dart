import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// TODO: create the actual folders and file destinations
//import 'components/map/map.dart';
//import 'components/characters/thief/thief.dart';
//import 'components/objects/object_behavior.dart';
//import 'levels/level_loader.dart';

class DetectiveGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFFFDB825); // black screen

  /* must override the following
    - onLoad(): loads assets, set up thief and objects for current level.
                await loadLevel();       // inside async function; 'await' for images to load and game objs to build before loading the level
                add(thief);              // add thief to the game world
                add(map);
                add(obj);
    - update(dt): to update the screen; for change over time (counting how long submission took, move the thief, how long disappearance animation takes)
                move thief: would move thief at x pix/sec to a position regardless of diff run speeds from diff devices
                count time: dt gets added per frame to act as a timer

                super.update(dt); let update do all its default stuff
                timer += dt; to count time
                thief.position.x += 100 * dt; consistently move thief 100 pix/sec to the right
   */
}
