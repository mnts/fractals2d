import 'package:fractal/index.dart';
import '../controllers/positions.dart';
import 'offset.dart';

class PositionFractal extends EventFractal {
  static final controller = PositionsCtrl(
    extend: EventFractal.controller,
    make: (d) => switch (d) {
      MP() => PositionFractal.fromMap(d),
      Object() || null => throw ('wrong event type')
    },
    attributes: <Attr>[
      Attr(
        name: 'x',
        format: FormatF.integer,
        isImmutable: true,
      ),
      Attr(
        name: 'y',
        format: FormatF.integer,
        isImmutable: true,
      ),
    ],
  );
  @override
  PositionsCtrl get ctrl => controller;
  OffsetF value;

  @override
  bool get deleteOlder => true;

  PositionFractal({
    super.id,
    required this.value,
    super.name,
    super.hash,
    super.createdAt,
    super.syncAt,
    super.to,
  });

  PositionFractal.fromMap(MP d)
      : value = OffsetF(
          (d['x'] ?? 0) + .0,
          (d['y'] ?? 0) + .0,
        ),
        super.fromMap(d);

  @override
  String get display => '${value.x} ⤨ ${value.y}';

  @override
  Object? operator [](key) => switch (key) {
        'x' => value.x.toInt(),
        'y' => value.y.toInt(),
        _ => super[key],
      };
}
