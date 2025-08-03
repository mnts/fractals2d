import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractal/index.dart';
import '../lib.dart';

class CanvasCtrl<T extends CanvasFractal> extends NodeCtrl<T> {
  CanvasCtrl({
    super.name = 'canvas',
    required super.make,
    required super.extend,
    super.attributes = const <Attr>[],
  });
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
  preload([type]) async {
    await super.preload();
    print('canvas done');
    return 1;
  }

  final shaped = <ShapeF, List<ComponentFractal>>{};
  static const wantedShapes = [ShapeF.triE, ShapeF.triW];
  @override
  consume(f) {
    switch (f) {
      case (ComponentFractal f) when wantedShapes.contains(f.shape):
        final list = shaped[f.shape] ??= [];
        list.add(f);
    }
    super.consume(f);
  }

  @override
  spread(thing) async {
    await preload();
    await whenLoaded;
    shaped[ShapeF.triE]?.firstOrNull?.spread(thing);
  }

  @override
  //get hashData => [...super.hashData, attr];

  CanvasFractal.fromMap(super.d) : super.fromMap();

  @override
  MP toMap() => {
        ...super.toMap(),
      };
}
