enum Direction { up, down, left, right, none }

Map<String, int> getMoveDirection(String input) {
  int dx, dy;
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
  return {
    'dx': dx,
    'dy': dy,
  };
}