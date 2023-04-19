import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Crate extends SpriteAnimationComponent with HasGameRef {
  int _moveCount = 0;
  late Vector2 coordinate;
  bool isGoal = false;

  late final SpriteAnimation _noAnimation;
  late final OpacityEffect _goalEffect = OpacityEffect.fadeOut(
    EffectController(
      duration: 0.6,
      reverseDuration: 0.6,
      infinite: true,
    ),
  );
  // late final ColorEffect _goalEffect = ColorEffect(
  //   Colors.blue,
  //   const Offset(
  //     0.2,
  //     0.8,
  //   ),
  //   EffectController(
  //     duration: 0.8,
  //     reverseDuration: 0.8,
  //     infinite: true,
  //   ),
  // );

  Crate()
      : super(
    size: Vector2.all(64.0),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {animation = _noAnimation});
  }

  @override
  void update(double delta) {
    super.update(delta);
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('crate.png'),
      srcSize: Vector2.all(64.0),
    );

    _noAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 1, to: 1);
  }

  void setPosition(Vector2 vec) {
    coordinate = vec;
  }

  move(Vector2 vec) {
    moveFunc((vec - coordinate) * 64.0);
    setPosition(vec);
  }

  void moveFunc(Vector2 vac) {
    position.add(vac);
  }

  void goalCheck(List<Vector2> vacList) {
    isGoal = vacList.any((vec) => coordinate == vec);

    if (isGoal && !_goalEffect.isMounted) {
      add(_goalEffect);
    } else if(!isGoal) {
      if (_goalEffect.isMounted) {
        _goalEffect.apply(0);
        _goalEffect.removeFromParent();
      }
    }
  }
}