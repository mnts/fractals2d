import 'package:fractal/controllers/events.dart';
import '../models/component.dart';

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
