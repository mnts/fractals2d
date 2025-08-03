import 'package:fractal/index.dart';
import '../models/canvas.dart';
import '../models/component.dart';
import '../models/state.dart';
import '../props/offset.dart';

mixin CanvasMix on NodeFractal {
  final cState = CanvasState();

  int topZ = 1;

  NodeFractal? extLink;

  ComponentFractal? tap;

  late final position = OffsetProp(this);

  bool wheelZoom = true;

  @override
  get dontStore => true;

  updateCanvas() {
    notifyListeners();
  }

  late final components = CatalogFractal(
    filters: [
      {'to': hash}
    ],
    order: {'z': true},
    source: ComponentFractal.controller,
    kind: FKind.tmp,
  )..synch();

  LinkFractal? getLink(int id) {
    return Fractal.storage[id] as LinkFractal?;
  }

  removeComponent(ComponentFractal component) {
    list.removeWhere((f) => f == component);
    list.removeWhere((l) {
      if (component.linksIn.contains(l) || component.linksIn.contains(l)) {
        l.delete();
        return true;
      }
      return false;
    });

    notifyListeners();
  }

  removeComponentWithChildren(ComponentFractal component) {
    List<ComponentFractal> componentsToRemove = [];
    _removeComponentWithChildren(component, componentsToRemove);
    componentsToRemove.reversed.forEach(removeComponent);
  }

  _removeComponentWithChildren(
      ComponentFractal component, List<ComponentFractal> toRemove) {
    toRemove.add(component);
    /*
    for (var child in component.childrenIds) {
      _removeComponentWithChildren(child, toRemove);
    }
    */
  }

  removeComponentConnections(int id) {
//    assert(ComponentFractal.controller.map.containsKey(id));

    /*
    List<int> _linksToRemove = [];

    getComponent(id).connections.forEach((connection) {
      _linksToRemove.add(connection);
    });

    _linksToRemove.forEach(removeLink);
    */
    notifyListeners();
  }

  int moveComponentToTheFront(ComponentFractal component) {
    int zOrderMax = component.z;
    final l = list.whereType<ComponentFractal>();
    for (var component in l) {
      if (component.z > zOrderMax) {
        zOrderMax = component.z;
      }
    }
    component.z = zOrderMax + 1;
    notifyListeners();
    return zOrderMax + 1;
  }

  int moveComponentToTheBack(ComponentFractal component) {
    int zOrderMin = component.z;
    final l = list.whereType<ComponentFractal>();
    for (var component in l) {
      if (component.z < zOrderMin) {
        zOrderMin = component.z;
      }
    }
    component.z = zOrderMin - 1;
    notifyListeners();
    return zOrderMin - 1;
  }

  removeLink(LinkFractal link) {
    if (link.to case WithLinksF source) {
      source.removeConnection(link);
    }
    if (link.target case WithLinksF target) {
      target.removeConnection(link);
    }
    if (link.to case CanvasFractal canvas) {
      canvas
        ..list.remove(link)
        ..notify(link);
    }

    link.delete();
    notifyListeners();
  }

  removeAllLinks() {
    final l = list.whereType<ComponentFractal>();
    for (var component in l) {
      removeComponentConnections(component.id);
    }
  }
}
