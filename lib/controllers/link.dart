import 'package:fractal_base/models/index.dart';
import 'package:signed_fractal/controllers/events.dart';
import '../models/link_data.dart';

class LinksCtrl<T extends LinkFractal> extends EventsCtrl<T> {
  LinksCtrl({
    super.name = 'link',
    required super.make,
    required super.extend,
    super.attributes = const [
      Attr('target', String),
      Attr('source', String),
    ],
  }) {
    //initSql();
  }
}
