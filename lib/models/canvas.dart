import 'package:fractal/lib.dart';
import 'package:fractals2d/models/policy.dart';
import 'package:position_fractal/props/position.dart';
import 'package:signed_fractal/signed_fractal.dart';
import 'component.dart';
import 'link_data.dart';
import 'state.dart';
import 'package:signed_fractal/models/event.dart';

mixin CanvasMix on EventFractal {
  final components = <ComponentFractal>[];
  final links = LinkFractal.controller;
  final state = CanvasState();

  //bool filter(ComponentFractal c) =>

  @override
  canvasConsume(event) {
    if (event is ComponentFractal) {
      components.add(event);
      notifyListeners();
    }
    //super.consume(event);
  }

  late final position = OffsetProp(this);

  @override
  get dontStore => true;

  updateCanvas() {
    notifyListeners();
  }

  bool linkExists(int id) {
    return links.contains(id);
  }

  bool componentExists(int id) {
    return components.contains(id);
  }

  LinkFractal getLink(int id) {
    return links[id]!;
  }

  ComponentFractal getComponent(int id) => ComponentFractal.controller[id]!;

  removeComponent(int id) {
    assert(
      componentExists(id),
      'model does not contain this component id: $id',
    );

    removeComponentParent(id);
    removeParentFromChildren(id);
    removeComponentConnections(id);
    ComponentFractal.controller.remove(id);
    notifyListeners();
  }

  /// Removes the component's parent from a component.
  ///
  /// It also removes child from former parent.
  removeComponentParent(int componentId) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    final _parentId = getComponent(componentId).parentId;
    if (_parentId != null) {
      getComponent(componentId).removeParent();
      getComponent(_parentId).removeChild(componentId);
    }
  }

  removeParentFromChildren(componentId) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    final _component = getComponent(componentId);
    final _childrenToRemove = List.from(_component.childrenIds);
    _childrenToRemove.forEach((childId) {
      removeComponentParent(childId);
    });
  }

  /// Removes a component with [componentId] and also removes all its children components.
  removeComponentWithChildren(int componentId) {
    assert(componentExists(componentId),
        'model does not contain this component id: $componentId');
    List<int> componentsToRemove = [];
    _removeComponentWithChildren(componentId, componentsToRemove);
    componentsToRemove.reversed.forEach(removeComponent);
  }

  _removeComponentWithChildren(int componentId, List<int> toRemove) {
    toRemove.add(componentId);
    getComponent(componentId).childrenIds.forEach((childId) {
      _removeComponentWithChildren(childId, toRemove);
    });
  }

  removeComponentConnections(int id) {
    assert(ComponentFractal.controller.keys.contains(id));

    List<int> _linksToRemove = [];

    getComponent(id).connections.forEach((connection) {
      _linksToRemove.add(connection.connectionId);
    });

    _linksToRemove.forEach(removeLink);
    notifyListeners();
  }

  setComponentZOrder(int componentId, int zOrder) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    getComponent(componentId).zOrder = zOrder;
    notifyListeners();
  }

  /// You cannot use is during any movement, because the order will change so the moving item will change.
  /// Returns new zOrder
  int moveComponentToTheFront(int componentId) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    int zOrderMax = getComponent(componentId).zOrder;
    for (var component in components) {
      if (component.zOrder > zOrderMax) {
        zOrderMax = component.zOrder;
      }
    }
    getComponent(componentId).zOrder = zOrderMax + 1;
    notifyListeners();
    return zOrderMax + 1;
  }

  /// You cannot use is during any movement, because the order will change so the moving item will change.
  /// /// Returns new zOrder
  int moveComponentToTheBack(int componentId) {
    assert(
      componentExists(componentId),
      'model does not contain this component id: $componentId',
    );
    int zOrderMin = getComponent(componentId).zOrder;
    for (var component in components) {
      if (component.zOrder < zOrderMin) {
        zOrderMin = component.zOrder;
      }
    }
    getComponent(componentId).zOrder = zOrderMin - 1;
    notifyListeners();
    return zOrderMin - 1;
  }

  removeLink(int linkId) {
    assert(linkExists(linkId), 'model does not contain this link id: $linkId');

    getComponent(getLink(linkId).sourceComponentId).removeConnection(linkId);
    getComponent(getLink(linkId).targetComponentId).removeConnection(linkId);
    links.remove(linkId);
    notifyListeners();
  }

  removeAllLinks() {
    for (var component in components) {
      removeComponentConnections(component.id);
    }
  }
}
