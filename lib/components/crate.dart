import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Crate extends SpriteAnimationComponent with HasGameRef {
  int _moveCount = 0;
  late Vector2 coordinate;

  late final SpriteAnimation _noAnimation;

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
    // _moveCount -= _moveCoordinate as int;
    position.add(vac);
  }
}