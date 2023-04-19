import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:push_puzzle/src/stage_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('Test stage state of game initialization.', () {
    late StageState state;

    setUp(() {
      state = StageState();
      // Initial State
      // ########
      // # .. p #
      // # oo   #
      // #      #
      // ########
    });

    group('public Getter', () {
      test('playerIndex', () {
        expect(state.playerIndex, 13);
      });
      test('isCrateMove', () {
        expect(state.isCrateMove, false);
      });
      test('isClear', () {
        expect(state.isClear, false);
      });
      test('playerVecPos', () {
        expect(state.playerVecPos, Vector2(5.0, 1.0));
      });
      test('crateIndexList', () {
        expect(state.crateIndexList, [18, 19]);
      });
      test('crateVecList', () {
        expect(state.crateVecList, [Vector2(2.0, 2.0), Vector2(3.0, 2.0)]);
      });
      test('crateOnGoalIndexList', () {
        expect(state.crateOnGoalIndexList, []);
      });
      test('crateOnGoalVecList', () {
        expect(state.crateOnGoalVecList, []);
      });
      test('splitStageStateList', () {
        expect(state.splitStageStateList, ['########', '# .. p #', '# oo   #', '#      #', '########']);
      });
    });
  });
}
