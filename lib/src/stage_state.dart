import 'dart:convert';

import 'package:flame/components.dart';

import '../utility/object_enum.dart';
import '../utility/stage_master_data.dart';
import '../utility/direction.dart';

class StageState {
  late int stageWidth;
  late int stageHeight;
  late List<String> stageDataList;
  late List<Object> stageState = initStageState;

  bool _isCrateMove = false;
  late Vector2 crateMoveBeforeVec;
  late Vector2 crateMoveAfterVec;

  StageState({int stage = 1}) {
    changeStage(stage);
  }

  void changeStage(int stage) {
    stageDataList = LineSplitter.split(stageMasterDataList[stage - 1]).toList();
    stageWidth = stageDataList.first.length;
    stageHeight = stageDataList.length;
    stageState = initStageState;
  }

  List<Object> get initStageState {
    final List<Object> stageStateList =
        List<Object>.filled(stageWidth * stageHeight, Object.unknown);
    int x, y;
    x = y = 0;

    for (var stageData in stageDataList) {
      for (var rune in stageData.runes) {
        final Object t = Object.fromValue(String.fromCharCode(rune));
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
      stageState[targetPosition] == Object.crate ||
      stageState[targetPosition] == Object.crateOnGoal;

  bool isWorldOut(tx, ty) =>
      tx < 0 || ty < 0 || tx >= stageWidth || ty >= stageHeight;

  bool isSpaceOrGoal(int targetPosition) =>
      stageState[targetPosition] == Object.space ||
      stageState[targetPosition] == Object.goal;

  bool get isClear => stageState.indexWhere((obj) => obj == Object.crate) == -1;

  Map<String, int> get playerVecPos =>
      {'x': playerIndex % stageWidth, 'y': playerIndex ~/ stageWidth};

  Vector2 getVecPos(int index) => Vector2((index % stageWidth) as double, (index ~/ stageWidth) as double);

  List<int> get crateIndexList {
    List<int> indices = [];
    for (int i = 0; i < stageState.length; i++) {
      if (stageState[i] == Object.crate) {
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
      if (stageState[i] == Object.crateOnGoal) {
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
        ? Object.crateOnGoal
        : Object.crate;
  }

  void replaceCrateLeave(int targetPosition) {
    stageState[targetPosition] =
        (stageState[targetPosition] == Object.crateOnGoal)
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
