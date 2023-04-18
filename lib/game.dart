import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';
import 'src/push_game.dart';
import 'utility/direction.dart';

class MainGame extends FlameGame with KeyboardEvents, HasGameRef {
  PushGame pushGame = PushGame();
  final Player _player = Player();
  final double _blockSize = 64;

  @override
  Color backgroundColor() => const Color.fromRGBO(89, 106, 108, 1.0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await draw();
    pushGame.draw();
  }

  Future<void> draw() async {
    final blockSprite = await Sprite.load('block.png');
    final crateSprite = await Sprite.load('crate.png');
    final goalSprite = await Sprite.load('goal.png');

    final spriteMap = {
      '#': blockSprite,
      'o': crateSprite,
      '.': goalSprite,
    };

    for (var i = 0; i < pushGame.splitStageStateList.length; i++) {
      final row = pushGame.splitStageStateList[i];
      for (var j = 0; j < row.length; j++) {
        final char = row[j];
        if (spriteMap.containsKey(char)) {
          final sprite = spriteMap[char];
          final component = SpriteComponent(
            size: Vector2.all(_blockSize),
            sprite: sprite,
            position: Vector2(j * _blockSize, i * _blockSize),
          );
          add(component);
        }
        if (char == 'p') {
          _player.position = Vector2(j * _blockSize, i * _blockSize);
        }
      }
    }
    add(_player);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction keyDirection = Direction.none;

    if (!isKeyDown || _player.moveCount != 0)
      return super.onKeyEvent(event, keysPressed);

    if (event.logicalKey == LogicalKeyboardKey.keyA ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      keyDirection = Direction.down;
    }

    bool isMove = pushGame.changeState(keyDirection.name);
    if (isMove) playerMove(isKeyDown, keyDirection);

    return super.onKeyEvent(event, keysPressed);
  }

  void playerMove(bool isKeyDown, Direction keyDirection) {
    if (isKeyDown && keyDirection != Direction.none) {
      _player.direction = keyDirection;
      _player.moveCount = _blockSize as int;
    } else if (_player.direction == keyDirection) {
      _player.direction = Direction.none;
    }
  }
}
