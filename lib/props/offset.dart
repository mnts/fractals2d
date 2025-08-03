import '../models/offset.dart';
import 'coord.dart';

class OffsetProp<T extends OffsetF> extends CoordProp<T> {
  double get x => value.x;
  double get y => value.y;

  double get dx => value.x;
  double get dy => value.y;

  @override
  String get name => _name;
  static final _name = 'position';
  OffsetProp(
    super.parent, {
    super.value = OffsetF.zero,
  });
}
