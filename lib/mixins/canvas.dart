import 'package:position_fractal/props/position.dart';
import 'package:signed_fractal/signed_fractal.dart';
import '../models/component.dart';
import '../models/link_data.dart';
import '../models/state.dart';

mixin CanvasMix on NodeFractal {
  final cState = CanvasState();
  //final components = <ComponentFractal>[];
  /*
  final components = MapF<ComponentFractal>();
  final links = MapF<LinkFractal>();

  //final links = <LinkFractal>[];

  //bool filter(ComponentFractal c) =>

  canvasConsume(event) {
    if (event is ComponentFractal) {
      components.input(event);
      notifyListeners();
    }
    if (event is LinkFractal) {
      links.input(event);
      notifyListeners();
    }
    //super.consume(event);
  }
  */

  late final position = OffsetProp(this);

  @override
  get dontStore => true;

  updateCanvas() {
    notifyListeners();
  }

  /*
  bool linkExists(int id) {
    return links.byId(id) != null;
  }

  bool componentExists(int id) {
    return components.byId(id) != null;
  }

  */
  LinkFractal? getLink(int id) {
    return Fractal.map[id] as LinkFractal?;
  }

  removeComponent(ComponentFractal component) {
    list.removeWhere((f) => f == component);
    list.removeWhere((l) {
      if (component.linksIn.contains(l) || component.linksIn.contains(l)) {
        l.remove();
        return true;
      }
      return false;
    });

    notifyListeners();
  }

  /// Removes the component's parent from a component.
  ///
  /// It also removes child from former parent.
  removeComponentParent(ComponentFractal component) {
/*    final _parentId = component.parent;
    if (_parentId != null) {
      component.removeParent();
      _parentId.removeChild(componentId);
    }
  */
  }

  removeParentFromChildren(ComponentFractal component) {
    final _childrenToRemove = List.from(component.childrenIds);
    for (var childId in _childrenToRemove) {
      removeComponentParent(childId);
    }
  }

  /// Removes a component with [componentId] and also removes all its children components.
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

  setComponentZOrder(ComponentFractal component, int zOrder) {
    /*
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    */
    component.zOrder = zOrder;
    notifyListeners();
  }

  /// You cannot use is during any movement, because the order will change so the moving item will change.
  /// Returns new zOrder
  int moveComponentToTheFront(ComponentFractal component) {
    int zOrderMax = component.zOrder;
    final l = list.whereType<ComponentFractal>();
    for (var component in l) {
      if (component.zOrder > zOrderMax) {
        zOrderMax = component.zOrder;
      }
    }
    component.zOrder = zOrderMax + 1;
    notifyListeners();
    return zOrderMax + 1;
  }

  /// You cannot use is during any movement, because the order will change so the moving item will change.
  /// /// Returns new zOrder
  int moveComponentToTheBack(ComponentFractal component) {
    int zOrderMin = component.zOrder;
    final l = list.whereType<ComponentFractal>();
    for (var component in l) {
      if (component.zOrder < zOrderMin) {
        zOrderMin = component.zOrder;
      }
    }
    component.zOrder = zOrderMin - 1;
    notifyListeners();
    return zOrderMin - 1;
  }

  removeLink(LinkFractal link) {
    //assert(linkExists(linkId), 'model does not contain this link id: $linkId');

    link.source.removeConnection(link);
    link.target.removeConnection(link);
    if (link.to case CanvasFractal canvas) {
      canvas
        ..list.remove(link)
        ..notify(link);
    }

    link.remove();
    notifyListeners();
  }

  removeAllLinks() {
    final l = list.whereType<ComponentFractal>();
    for (var component in l) {
      removeComponentConnections(component.id);
    }
  }
}
