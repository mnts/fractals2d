import 'package:fractal/lib.dart';
import 'package:fractal_socket/index.dart';
import 'package:position_fractal/fractals/index.dart';
import 'package:signed_fractal/models/event.dart';

import 'fractals2d.dart';

export 'lib.dart';

class Fractals2d {
  static final ctrls = <FractalCtrl>[
    SizeFractal.controller,
    PositionFractal.controller,
    ComponentFractal.controller,
    EventFractal.controller,
    Fractal.controller,
  ];

  static Future<int> init() async {
    for (final el in ctrls.reversed) {
      await el.init();
    }
    FSocketMix.initiate();
    return 1;
  }
}
