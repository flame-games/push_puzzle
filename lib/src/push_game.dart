import 'package:flame/components.dart';

import 'stage_state.dart';

class PushGame {
  late StageState state;

  PushGame() {
    state = StageState();
  }

  void draw() {
    for (var splitStageState in state.splitStageStateList) {
      print(splitStageState);
    }
  }

  void update(String input) {
    changeState(input);
    draw();
    if (state.isClear) {
      print("Congratulation's! you won.");
    }
  }

  bool changeState(String input) {
    return state.changeState(input);
  }
}
