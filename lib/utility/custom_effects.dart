import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

OpacityEffect customOpacityEffect = OpacityEffect.fadeOut(
  EffectController(
    duration: 0.6,
    reverseDuration: 0.6,
    infinite: true,
  ),
);

ColorEffect customColorEffect = ColorEffect(
  Colors.blue,
  const Offset(
    0.2,
    0.8,
  ),
  EffectController(
    duration: 0.8,
    reverseDuration: 0.8,
    infinite: true,
  ),
);