import '../lib.dart';

class PositionsCtrl<T extends PositionFractal> extends EventsCtrl<T> {
  PositionsCtrl({
    super.name = 'position',
    required super.make,
    required super.extend,
    required super.attributes,
  });
}
