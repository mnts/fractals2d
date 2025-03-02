import 'package:app_fractal/screen.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:signed_fractal/signed_fractal.dart';

class CanvasCtrl<T extends CanvasFractal> extends NodeCtrl<T> {
  CanvasCtrl({
    super.name = 'canvas',
    required super.make,
    required super.extend,
    super.attributes = const <Attr>[],
  });

  @override
  final icon = IconF(0xf523);
}

class CanvasFractal extends NodeFractal with CanvasMix {
  static final controller = CanvasCtrl(
    extend: NodeFractal.controller,
    make: (d) => switch (d) {
      MP() => CanvasFractal.fromMap(d),
      String s => CanvasFractal(name: s),
      Object() || null => throw ('wrong')
    },
  );

  @override
  get uis => ui;
  static var ui = <String>[];

  @override
  CanvasCtrl get ctrl => controller;

  CanvasFractal({
    required super.name,
    super.to,
  });

  @override
  //get hashData => [...super.hashData, attr];

  CanvasFractal.fromMap(super.d) : super.fromMap();

  @override
  MP toMap() => {
        ...super.toMap(),
      };

  @override
  consume(f) {
    //super.canvasConsume(f);
    super.consume(f);
  }
}
