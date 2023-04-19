import 'stage_state.dart';

class PushGame {
  late int _stage;
  late StageState state;

  PushGame({int stage = 1}) {
    _stage = stage;
    state = StageState(stage: stage);
  }

  int get stage => _stage;

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

  void nextStage() {
    _stage++;
    state.changeStage(_stage);
  }
}
