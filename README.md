# Sokoban Push Puzzle

<img width="600" src="https://user-images.githubusercontent.com/1584153/234482219-4cd323d9-67a0-47b4-af91-87308240276e.gif">

## Usage

```
flutter run
```

## Architecture

For stage data, [lib/utilty/stage_master_data.dart](https://github.com/flame-games/push_puzzle/blob/main/lib/utility/stage_master_data.dart) is referenced, and stages are generated as text data.

```dart
############
#     ## p #
#   o .. o #
############
```

The core logic of the game is located under lib/src and is mainly processed here and designed to be executable in CUI.

[lib/src/stage_state.dart](https://github.com/flame-games/push_puzzle/blob/main/lib/src/stage_state.dart) is the main process that manages the stage state, and [lib/src/push_game.dart](https://github.com/flame-games/push_puzzle/blob/main/lib/src/push_game.dart) is designed to encompass it.

Update positions of walls, characters, luggage, etc. as game conditions change.

```dart
############
#     ##   #
#  op .. o #
############
```

The other files under the lib are the Flutter and Flame processes for displaying on the screen as GUI.

## Getting Started

As for the content of the game, it is quite simple.

The stage is cleared by moving the character and carrying the luggage to the goal.

Character movement is mainly handled [here](https://github.com/flame-games/player_move).


### Input Reference

| Joypad | input | Direction |
| -------------- |:------------:|:------------:|
| UP     | LogicalKeyboardKey keyW | UP    |
| Left   | LogicalKeyboardKey keyA | Left  |
| right  | LogicalKeyboardKey keyD | right |
| Down   | LogicalKeyboardKey keyS | Down  |


## Contributor

### copyright holder

Sokoban (100+ tiles)

[Kenney](https://opengameart.org/content/sokoban-100-tiles)

I appreciate it very much.

## Author

**Daisuke Takayama**

-   [@webcyou](https://twitter.com/webcyou)
-   [@panicdragon](https://twitter.com/panicdragon)
-   <https://github.com/webcyou>
-   <https://github.com/webcyou-org>
-   <https://github.com/panicdragon>
-   <https://www.webcyou.com/>
