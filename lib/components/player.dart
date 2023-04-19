import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../utility/config.dart';
import '../utility/direction.dart';

class Player extends SpriteAnimationComponent with HasGameRef {
  final double _animationSpeed = 0.15;
  final double _moveCoordinate = 8;
  int _moveCount = 0;

  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  Direction direction = Direction.none;

  Player()
      : super(
          size: Vector2.all(oneBlockSize),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _standingAnimation});
  }

  set moveCount(int i) {
    _moveCount = i;
  }

  int get moveCount => _moveCount;

  @override
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  void movePlayer(double delta) {
    if (_moveCount == 0) return;

    switch (direction) {
      case Direction.up:
        animation = _runUpAnimation;
        moveFunc(Vector2(0, -_moveCoordinate));
        break;
      case Direction.down:
        animation = _runDownAnimation;
        moveFunc(Vector2(0, _moveCoordinate));
        break;
      case Direction.left:
        animation = _runLeftAnimation;
        moveFunc(Vector2(-_moveCoordinate, 0));
        break;
      case Direction.right:
        animation = _runRightAnimation;
        moveFunc(Vector2(_moveCoordinate, 0));
        break;
      case Direction.none:
        animation = _standingAnimation;
        break;
    }
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('sp_player.png'),
      srcSize: Vector2(84.0, 110.0),
    );

    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4);

    _runLeftAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4);

    _runUpAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4);

    _standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1);
  }

  void moveFunc(Vector2 vac) {
    _moveCount -= _moveCoordinate.toInt();
    position.add(vac);
  }
}
