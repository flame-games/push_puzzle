import 'dart:convert';

import 'package:flame/components.dart';

import '../utility/object_enum.dart';
import '../utility/stage_master_data.dart';
import '../utility/direction.dart';

class StageState {
  late int width;
  late int height;
  late List<String> dataList;
  late List<Object> objectList = initStageState;

  bool _isCrateMove = false;
  late Vector2 crateMoveBeforeVec;
  late Vector2 crateMoveAfterVec;
  late List<Vector2> goalVecList;

  StageState({int stage = 1}) {
    changeStage(stage);
  }

  void changeStage(int stage) {
    dataList = LineSplitter.split(stageMasterDataList[stage - 1]).toList();
    width = dataList.first.length;
    height = dataList.length;
    objectList = initStageState;
    goalVecList = _goalVecList;
  }

  List<Object> get initStageState {
    final List<Object> stageStateList =
        List<Object>.filled(width * height, Object.unknown);
    int x, y;
    x = y = 0;

    for (var stageData in dataList) {
      for (var rune in stageData.runes) {
        final Object t = Object.fromValue(String.fromCharCode(rune));
        if (t != Object.unknown) {
          stageStateList[y * width + x] = t;
          ++x;
        }
      }
      x = 0;
      ++y;
    }
    return stageStateList;
  }

  int get playerIndex => objectList
      .indexWhere((obj) => obj == Object.man || obj == Object.manOnGoal);

  bool get isCrateMove => _isCrateMove;

  bool isCrate(int targetPosition) =>
      objectList[targetPosition] == Object.crate ||
      objectList[targetPosition] == Object.crateOnGoal;

  bool isWorldOut(tx, ty) =>
      tx < 0 || ty < 0 || tx >= width || ty >= height;

  bool isSpaceOrGoal(int targetPosition) =>
      objectList[targetPosition] == Object.space ||
      objectList[targetPosition] == Object.goal;

  bool get isClear => objectList.indexWhere((obj) => obj == Object.crate) == -1;

  Vector2 get playerVecPos => Vector2((playerIndex % width).toDouble(), (playerIndex ~/ width).toDouble());

  Vector2 getVecPos(int index) => Vector2((index % width).toDouble(), (index ~/ width).toDouble());

  List<int> get crateIndexList {
    List<int> indices = [];
    for (int i = 0; i < objectList.length; i++) {
      if (objectList[i] == Object.crate) {
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
    for (int i = 0; i < objectList.length; i++) {
      if (objectList[i] == Object.crateOnGoal) {
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

  List<int> get _goalIndexList {
    List<int> indices = [];
    for (int i = 0; i < objectList.length; i++) {
      if (objectList[i] == Object.goal) {
        indices.add(i);
      }
    }
    return indices;
  }

  List<Vector2> get _goalVecList {
    List<Vector2> indices = [];
    for (var goalIndex in _goalIndexList) {
      indices.add(getVecPos(goalIndex));
    }
    return indices;
  }

  List<String> get splitStageStateList {
    final List<String> stageStateList = List<String>.filled(height, '');

    for (int y = 0; y < height; ++y) {
      String line = '';
      for (int x = 0; x < width; ++x) {
        line = '$line${objectList[y * width + x].displayName}';
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
    objectList[targetPosition] = (objectList[targetPosition] == Object.goal)
        ? Object.manOnGoal
        : Object.man;
  }

  void replacePlayerLeave(int playerPosition) {
    objectList[playerPosition] =
        (objectList[playerPosition] == Object.manOnGoal)
            ? Object.goal
            : Object.space;
  }

  void replaceCrateIn(int targetPosition) {
    objectList[targetPosition] = (objectList[targetPosition] == Object.goal)
        ? Object.crateOnGoal
        : Object.crate;
  }

  void replaceCrateLeave(int targetPosition) {
    objectList[targetPosition] =
        (objectList[targetPosition] == Object.crateOnGoal)
            ? Object.manOnGoal
            : Object.man;
  }

  bool changeState(String input) {
    _isCrateMove = false;
    int dx = getMoveDirection(input).x.toInt();
    int dy = getMoveDirection(input).y.toInt();
    int x = playerVecPos.x.toInt(); // modulus operator
    int y = playerVecPos.y.toInt(); // integer division operator

    // post move coordinate
    int tx = x + dx;
    int ty = y + dy;

    // Maximum and minimum coordinate checks
    if (isWorldOut(tx, ty)) return false;

    int p = y * width + x; // PlayerPosition
    int tp = ty * width + tx; // TargetPosition

    // Space or goal. People move.
    if (isSpaceOrGoal(tp)) {
      changePlayerObject(tp, p);
    } else if (isCrate(tp)) {
      // So two squares away is in range.
      int tx2 = tx + dx;
      int ty2 = ty + dy;

      // Impossible to push.
      if (isWorldOut(tx2, ty2)) return false;

      int tp2 = (ty + dy) * width + (tx + dx); // two squares away

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
