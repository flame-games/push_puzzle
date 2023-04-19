import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';
import 'components/crate.dart';

import 'src/push_game.dart';
import 'utility/direction.dart';

class MainGame extends FlameGame with KeyboardEvents, HasGameRef {
  PushGame pushGame = PushGame();
  final double _blockSize = 64;
  late Player _player;
  final List<Crate> _crateList = [];
  final List<SpriteComponent> _bgComponentList = [];
  late Map<String, Sprite> _spriteMap;

  @override
  Color backgroundColor() => const Color.fromRGBO(89, 106, 108, 1.0);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final blockSprite = await Sprite.load('block.png');
    final goalSprite = await Sprite.load('goal.png');
    _spriteMap = {
      '#': blockSprite,
      '.': goalSprite,
    };

    await draw();
  }

  Future<void> draw() async {
    for (var y = 0; y < pushGame.state.splitStageStateList.length; y++) {
      final row = pushGame.state.splitStageStateList[y];
      for (var x = 0; x < row.length; x++) {
        final char = row[x];

        if (_spriteMap.containsKey(char)) renderBackGround(_spriteMap[char], x, y);
        if (char == 'p') initPlayer(x, y);
        if (char == 'o') initCrate(x, y);
      }
    }

    add(_player);
    for(var crate in _crateList) {
      add(crate);
    }
    // camera.followComponent(_player);
  }

  void renderBackGround(sprite, x, y) {
    final component = SpriteComponent(
      size: Vector2.all(_blockSize),
      sprite: sprite,
      position: Vector2(x * _blockSize, y * _blockSize),
    );
    _bgComponentList.add(component);
    add(component);
  }

  void initPlayer(x, y) {
    _player = Player();
    _player.position = Vector2(x * _blockSize, y * _blockSize);
  }

  void initCrate(x, y) {
    final crate = Crate();
    crate.setPosition(Vector2(x, y));
    crate.position = Vector2(x * _blockSize, y * _blockSize);
    _crateList.add(crate);
  }

  void allReset() {
    remove(_player);
    for (var crate in _crateList) {
      remove(crate);
    }
    for (var bg in _bgComponentList) {
      remove(bg);
    }
    _crateList.clear();
    _bgComponentList.clear();
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction keyDirection = Direction.none;

    if (!isKeyDown || _player.moveCount != 0) {
      return super.onKeyEvent(event, keysPressed);
    }

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
    if (isMove) {
      playerMove(isKeyDown, keyDirection);

      if (pushGame.state.isCrateMove) {
        final targetCreate = _crateList.firstWhere((crate) => crate.coordinate == pushGame.state.crateMoveBeforeVec);
        targetCreate.move(pushGame.state.crateMoveAfterVec);
      }
      if (pushGame.state.isClear) {
        print("Congratulation's! you won.");
        pushGame.nextStage();
        allReset();
        draw();
      }
    }
    // pushGame.draw();

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
