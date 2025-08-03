import '../models/offset.dart';
import 'coord.dart';

class SizeProp<T extends SizeF> extends CoordProp<T> {
  double get width => value.width;
  double get height => value.height;

  @override
  String get name => _name;
  static final _name = 'size';
  SizeProp(super.parent) : super(value: SizeF.zero);
}
