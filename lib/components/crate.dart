import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/effects.dart';

import '../utility/config.dart';
import '../utility/custom_effects.dart';

class Crate extends SpriteAnimationComponent with HasGameRef {
  // int _moveCount = 0;
  late Vector2 coordinate;
  bool isGoal = false;

  late final SpriteAnimation _noAnimation;
  late final SpriteAnimation _goalAnimation;
  late final OpacityEffect _goalEffect;

  Crate()
      : super(
    size: Vector2.all(oneBlockSize),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _noAnimation});
    _goalEffect = customOpacityEffect;
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('crate.png'),
      srcSize: Vector2.all(oneBlockSize),
    );

    _noAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 1, to: 1);
    _goalAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.4, to: 2);
  }

  void setPosition(Vector2 vec) {
    coordinate = vec;
  }

  move(Vector2 vec) {
    moveFunc((vec - coordinate) * oneBlockSize);
    setPosition(vec);
  }

  void moveFunc(Vector2 vac) {
    position.add(vac);
  }

  void goalCheck(List<Vector2> vacList) {
    isGoal = vacList.any((vec) => coordinate == vec);

    // if (isGoal && !_goalEffect.isMounted) {
    //   add(_goalEffect);
    // } else if(!isGoal && _goalEffect.isMounted) {
    //   _goalEffect.apply(0);
    //   _goalEffect.removeFromParent();
    // }
    if (isGoal) {
      animation = _goalAnimation;
    } else {
      animation = _noAnimation;
    }
  }
}