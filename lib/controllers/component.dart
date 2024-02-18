import 'package:signed_fractal/controllers/events.dart';
import '../models/component.dart';
import 'package:fractal_base/models/index.dart';

class ComponentsCtrl<T extends ComponentFractal> extends EventsCtrl<T> {
  ComponentsCtrl({
    super.name = 'component',
    required super.extend,
    required super.make,
    required super.attributes,
  }) {
    //initSql();
  }
}
