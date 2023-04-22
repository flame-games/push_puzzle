import 'stage_state.dart';

class PushGame {
  late int _stage;
  late int step;
  late StageState state;

  PushGame({int stage = 1, this.step = 0}) {
    _stage = stage;
    state = StageState(stage: stage);
  }

  int get stage => _stage;
  bool get isFinalStage => state.dataList.length == stage;

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
    step++;
    return state.changeState(input);
  }

  void nextStage() {
    _stage++;
    step = 0;
    state.changeStage(_stage);
  }
}
