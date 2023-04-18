import 'dart:convert';

import '../utility/object_enum.dart';
import '../utility/stage_data.dart';

class PushGame {
  late int stageWidth;
  late int stageHeight;
  List<String> stageDataList = LineSplitter.split(stageData).toList();
  late List<Object> stageState = initStageState;

  PushGame() {
    stageWidth = stageDataList.first.length;
    stageHeight = stageDataList.length;
  }

  List<Object> get initStageState {
    final List<Object> stageStateList =
        List<Object>.filled(stageWidth * stageHeight, Object.unknown);
    int x, y;
    x = y = 0;

    for (var dataX in stageDataList) {
      for (var rune in dataX.runes) {
        final Object t;
        switch (String.fromCharCode(rune)) {
          case '#':
            t = Object.wall;
            break;
          case ' ':
            t = Object.space;
            break;
          case 'o':
            t = Object.block;
            break;
          case 'O':
            t = Object.blockOnGoal;
            break;
          case '.':
            t = Object.goal;
            break;
          case 'p':
            t = Object.man;
            break;
          case 'P':
            t = Object.manOnGoal;
            break;
          default:
            t = Object.unknown;
            break;
        }
        if (t != Object.unknown) {
          stageStateList[y * stageWidth + x] = t;
          ++x;
        }
      }
      x = 0;
      ++y;
    }
    return stageStateList;
  }

  int get playerIndex => stageState
      .indexWhere((obj) => obj == Object.man || obj == Object.manOnGoal);

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

  bool isCrate(int targetPosition) =>
      stageState[targetPosition] == Object.block ||
      stageState[targetPosition] == Object.blockOnGoal;

  bool isWorldOut(tx, ty) =>
      tx < 0 || ty < 0 || tx >= stageWidth || ty >= stageHeight;

  bool isSpaceOrGoal(int targetPosition) =>
      stageState[targetPosition] == Object.space ||
      stageState[targetPosition] == Object.goal;

  bool get isClear => stageState.indexWhere((obj) => obj == Object.block) == -1;

  Map<String, int> get playerVecPos =>
      {'x': playerIndex % stageWidth, 'y': playerIndex ~/ stageWidth};

  List<String> get splitStageStateList {
    final List<String> stageStateList = List<String>.filled(stageHeight, '');

    for (int y = 0; y < stageHeight; ++y) {
      String line = '';
      for (int x = 0; x < stageWidth; ++x) {
        line = '$line${stageState[y * stageWidth + x].displayName}';
      }
      stageStateList[y] = line;
      line = '';
    }
    return stageStateList;
  }

  void draw() {
    for (var splitStageState in splitStageStateList) {
      print(splitStageState);
    }
  }

  void update(String input) {
    changeState(input);
    draw();
    if (isClear) {
      print("Congratulation's! you won.");
    }
  }

  void changePlayerObject(int targetPosition, int playerPosition) {
    replacePlayerIn(targetPosition);
    replacePlayerLeave(playerPosition);
  }

  void replacePlayerIn(int targetPosition) {
    stageState[targetPosition] = (stageState[targetPosition] == Object.goal)
        ? Object.manOnGoal
        : Object.man;
  }

  void replacePlayerLeave(int playerPosition) {
    stageState[playerPosition] =
        (stageState[playerPosition] == Object.manOnGoal)
            ? Object.goal
            : Object.space;
  }

  void replaceCrateIn(int targetPosition) {
    stageState[targetPosition] = (stageState[targetPosition] == Object.goal)
        ? Object.blockOnGoal
        : Object.block;
  }

  void replaceCrateLeave(int targetPosition) {
    stageState[targetPosition] =
        (stageState[targetPosition] == Object.blockOnGoal)
            ? Object.manOnGoal
            : Object.man;
  }

  bool changeState(String input) {
    int? dx = getMoveDirection(input)['dx'];
    int? dy = getMoveDirection(input)['dy'];
    int? x = playerVecPos['x']; // modulus operator
    int? y = playerVecPos['y']; // integer division operator
    // post move coordinate
    int tx = x! + dx!;
    int ty = y! + dy!;
    // Maximum and minimum coordinate checks
    if (isWorldOut(tx, ty)) return false;

    int p = y * stageWidth + x; // PlayerPosition
    int tp = ty * stageWidth + tx; // TargetPosition

    // Space or goal. People move.
    if (isSpaceOrGoal(tp)) {
      changePlayerObject(tp, p);
    } else if (isCrate(tp)) {
      // So two squares away is in range.
      int tx2 = tx + dx;
      int ty2 = ty + dy;

      // Impossible to push.
      if (isWorldOut(tx2, ty2)) return false;

      int tp2 = (ty + dy) * stageWidth + (tx + dx); // two squares away

      // sequential replacement
      if (isSpaceOrGoal(tp2)) {
        replaceCrateIn(tp2);
        replaceCrateLeave(tp);
        replacePlayerLeave(p);
      }
    } else {
      return false;
    }
    return true;
  }
}
