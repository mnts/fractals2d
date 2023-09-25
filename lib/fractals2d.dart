import 'package:app_fractal/index.dart';
import 'package:fractal/lib.dart';
import 'package:fractal_socket/index.dart';
import 'package:position_fractal/fractals/index.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:signed_fractal/models/rewriter.dart';
import 'package:signed_fractal/signed_fractal.dart';

import 'fractals2d.dart';
import 'models/canvas.dart';

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
    FSocketMix.initiate();
    return 1;
  }
}
