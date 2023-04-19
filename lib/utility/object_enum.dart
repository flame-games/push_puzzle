enum Object {
  space(' '),
  wall('#'),
  goal('.'),
  crate('o'),
  crateOnGoal('O'),
  man('p'),
  manOnGoal('P'),
  unknown('');

  const Object(this.displayName);

  final String displayName;

  static Object fromValue(String value) => Object.values.firstWhere((o) => o.displayName == value);
}
