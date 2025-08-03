import 'fractals2d.dart';
export 'package:fractal/index.dart';
export 'lib.dart';

class Fractals2d {
  static final functions = <String,
      Future<PulseF?> Function(
    SparkF,
    //LinkFractal,
  )>{};

  static final ctrls = <FractalCtrl>[
    CanvasFractal.controller,
    SizeFractal.controller,
    PositionFractal.controller,
    LinkFractal.controller,
    ComponentFractal.controller,
  ];

  static Future<int> init() async {
    await SignedFractal.init();
    for (final el in ctrls.reversed) {
      await el.init();
    }

    return 1;
  }
}
