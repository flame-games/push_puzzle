import 'dart:convert';

import 'package:flame/components.dart';

import '../utility/object_enum.dart';
import '../utility/stage_data.dart';
import '../utility/direction.dart';

class StageState {
  late int stageWidth;
  late int stageHeight;
  List<String> stageDataList = LineSplitter.split(stageData).toList();
  late List<Object> stageState = initStageState;

  bool _isCrateMove = false;
  late Vector2 crateMoveBeforeVec;
  late Vector2 crateMoveAfterVec;

  StageState() {
    stageWidth = stageDataList.first.length;
    stageHeight = stageDataList.length;
  }

  List<Object> get initStageState {
    final List<Object> stageStateList =
        List<Object>.filled(stageWidth * stageHeight, Object.unknown);
    int x, y;
    x = y = 0;

    for (var stageData in stageDataList) {
      for (var rune in stageData.runes) {
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

  bool get isCrateMove => _isCrateMove;

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

  Vector2 getVecPos(int index) => Vector2((index % stageWidth) as double, (index ~/ stageWidth) as double);

  List<int> get crateIndexList {
    List<int> indices = [];
    for (int i = 0; i < stageState.length; i++) {
      if (stageState[i] == Object.block) {
        indices.add(i);
      }
    }
    return indices;
  }

  List<Vector2> get crateVecList {
    List<Vector2> indices = [];
    for (var crateIndex in crateIndexList) {
      indices.add(getVecPos(crateIndex));
    }
    return indices;
  }

  List<int> get crateOnGoalIndexList {
    List<int> indices = [];
    for (int i = 0; i < stageState.length; i++) {
      if (stageState[i] == Object.blockOnGoal) {
        indices.add(i);
      }
    }
    return indices;
  }

  List<Vector2> get crateOnGoalVecList {
    List<Vector2> indices = [];
    for (var crateOnGoalIndex in crateOnGoalIndexList) {
      indices.add(getVecPos(crateOnGoalIndex));
    }
    return indices;
  }

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
    _isCrateMove = false;
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
        _isCrateMove = true;
        crateMoveBeforeVec = getVecPos(tp);
        crateMoveAfterVec = getVecPos(tp2);

        replaceCrateIn(tp2);
        replaceCrateLeave(tp);
        replacePlayerLeave(p);
      } else {
        return false;
      }
    } else {
      return false;
    }
    return true;
  }
}
