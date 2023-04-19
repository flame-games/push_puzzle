import 'package:flame/components.dart';

enum Direction { up, down, left, right, none }

Vector2 getMoveDirection(String input) {
  double dx, dy;
  dx = dy = 0;

  switch (input) {
    case 'left':
      dx = -1;
      break;
    case 'right':
      dx = 1;
      break;
    case 'up':
      dy = -1;
      break;
    case 'down':
      dy = 1;
      break;
  }
  return Vector2(dx, dy);
}