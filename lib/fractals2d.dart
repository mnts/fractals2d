import 'package:app_fractal/index.dart';
import 'package:position_fractal/fractals/index.dart';
import 'fractals2d.dart';

export 'lib.dart';

class Fractals2d {
  static final ctrls = <FractalCtrl>[
    CanvasFractal.controller,
    SizeFractal.controller,
    PositionFractal.controller,
    LinkFractal.controller,
    ComponentFractal.controller,
  ];

  static Future<int> init() async {
    await SignedFractal.init();
    await AppFractal.init();
    for (final el in ctrls.reversed) {
      await el.init();
    }
    return 1;
  }
}
