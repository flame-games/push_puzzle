import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'utility/direction.dart';
import 'src/push_game.dart';

class MainGame extends FlameGame with KeyboardEvents, HasGameRef {
  PushGame pushGame = PushGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    pushGame.draw();
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction keyDirection = Direction.none;

    if (!isKeyDown) return super.onKeyEvent(event, keysPressed);

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      keyDirection = Direction.down;
    }

    pushGame.update(keyDirection.name);

    return super.onKeyEvent(event, keysPressed);
  }
}
