enum Object {
  space(' '),
  wall('#'),
  goal('.'),
  block('o'),
  blockOnGoal('O'),
  man('p'),
  manOnGoal('P'),
  unknown('');

  const Object(this.displayName);

  final String displayName;
}
