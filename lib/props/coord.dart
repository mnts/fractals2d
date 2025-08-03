import 'package:fractal/frac/frac.dart';
import 'package:fractal/models/event.dart';

import '../models/offset.dart';

abstract class CoordProp<T extends OffsetBaseF> extends Fr<T> {
  late dynamic _value;
  @override
  T get value => _value;

  @override
  set value(v) {
    _value = v;
    parent.notifyListeners();
  }

  EventFractal parent;
  late EventFractal stored;
  CoordProp(this.parent, {required OffsetBaseF value}) {
    _value = value;
  }

  /*
  init() {
    ctrl.listen((coord) {
      if (coord.idEvent == parent.id) {
        value = (coord as dynamic).value;
      }
    });
  }
  */

  String get name => 'coord';

  final _timed = TimedF();
  //late final positions = db.select(DB.main.positions).watch();
  move(OffsetBaseF offset) {
    value = offset;
    if (offset case OffsetF offset) {
      if (offset.x == 0 && offset.y == 0) return;
    }
    //parent.move();
    _timed.hold(() async {
      if (parent.dontStore) return;
      stored = await offset.store(parent);
    });

    /*
    PositionsCompanion.insert(
      title: '',
      x: x,
      y: y,
      content: '',
    );
    */
  }
}
