import 'package:app_fractal/screen.dart';
import 'package:fractal/lib.dart';
import 'package:fractals2d/mixins/canvas.dart';

class CanvasCtrl<T extends CanvasFractal> extends ScreenCtrl<T> {
  CanvasCtrl({
    super.name = 'canvas',
    required super.make,
    required super.extend,
    super.attributes = const <Attr>[],
  });

  @override
  final icon = IconF(0xf523);
}

class CanvasFractal extends ScreenFractal with CanvasMix {
  static final controller = CanvasCtrl(
    extend: ScreenFractal.controller,
    make: (d) => switch (d) {
      MP() => CanvasFractal.fromMap(d),
      String s => CanvasFractal(name: s),
      Object() || null => throw ('wrong')
    },
  );

  @override
  CanvasCtrl get ctrl => controller;

  CanvasFractal({
    required super.name,
    super.to,
  });

  /*
  @override
  consume(event) {
    //canvasConsume(event);
    return super.consume(event);
  }
  */

  @override
  //get hashData => [...super.hashData, attr];

  CanvasFractal.fromMap(MP d) : super.fromMap(d);

  @override
  MP toMap() => {
        ...super.toMap(),
      };
}
