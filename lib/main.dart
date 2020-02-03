import 'package:flutter/material.dart';
import 'package:kjh_clock/kjh_clock.dart';

import 'customizer.dart';
import 'model.dart';

void main() => runApp(ClockCustomizer((ClockModel model) => KjhClock(model)));
