import 'package:app_fractal/index.dart';
import 'package:fractal/lib.dart';
import 'package:fractal_socket/index.dart';
import 'package:position_fractal/fractals/index.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:signed_fractal/models/rewriter.dart';

import 'fractals2d.dart';

export 'lib.dart';

class Fractals2d {
  static final ctrls = <FractalCtrl>[
    AppFractal.controller,
    ScreenFractal.controller,
    UserFractal.controller,
    NodeFractal.controller,
    SizeFractal.controller,
    PositionFractal.controller,
    ComponentFractal.controller,
    WriterFractal.controller,
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
