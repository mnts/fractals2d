import 'package:color/color.dart';
import 'package:fractal/lib.dart';
import 'package:position_fractal/fractals/index.dart';
import 'package:position_fractal/props/position.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/models/rewriter.dart';
import '../controllers/component.dart';
import 'connection.dart';

class ComponentFractal extends EventFractal implements Rewritable {
  static final controller = ComponentsCtrl(
    extend: EventFractal.controller,
    name: 'component',
    make: (d) => switch (d) {
      MP() => ComponentFractal.fromMap(d),
      null || Object() => throw ('wrong event type')
    },
  );

  @override
  ComponentsCtrl get ctrl => controller;

  Color color;

  Color borderColor = const Color.rgb(55, 55, 55);
  double borderWidth = 3;
  double textSize = 18;

  late final size = SizeProp(this);
  late final position = OffsetProp(this);

  @override
  consume(event) {
    switch (event) {
      case (PositionFractal f):
        position.value = f.value;
      case (SizeFractal f):
        size.value = f.value;
    }
    super.consume(event);
  }

  /// This value determines if this component will be above or under other components.
  /// Higher value means on the top.
  int zOrder = --topZ;

  static int topZ = 999;

  /// Assigned parent to this component.
  ///
  /// Use for hierarchical components.
  /// Functions such as [moveComponentWithChildren] work with this property.
  int? parentId;

  /// List of children of this component.
  ///
  /// Use for hierarchical components.
  /// Functions such as [moveComponentWithChildren] work with this property.
  final List<int> childrenIds = [];

  /// Defines to which components is this components connected and what is the [connectionId].
  ///
  /// The connection can be [ConnectionOut] for link going from this component
  /// or [ConnectionIn] for link going from another to this component.
  final List<Connection> connections = [];

  /// Dynamic data for you to define your own data for this component.

  /// Represents data of a component in the model.
  static const defaultColor = Color.rgb(255, 255, 255);

  EventFractal? data;

  ComponentFractal({
    super.id,
    required SizeF size,
    super.to,
    required OffsetF position,
    this.color = defaultColor,
    this.data,
  }) {
    this.size.move(size);
    this.position.move(position);
    if (data != null) {
      dataHash = data!.hash;
    }
  }

  //get hashData => [...super.hashData];

  MP get _map => {
        'data': data?.hash ?? dataHash ?? '',
        'z': 0,
      };

  @override
  MP toMap() => {
        ...super.toMap(),
        ..._map,
      };

  /// Updates this component on the canvas.
  ///
  /// Use this function if you somehow changed the component data and you want to propagate the change to canvas.
  /// Usually this is already called in most functions such as [move] or [setSize] so it's not necessary to call it again.
  ///
  /// It calls [notifyListeners] function of [ChangeNotifier].
  updateComponent() {
    notifyListeners();
  }

  bool isHighlightVisible = false;

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }

  /// Adds new connection to this component.
  ///
  /// Do not use it if you are not sure what you do. This is called in [connectTwoComponents] function.
  addConnection(Connection connection) {
    connections.add(connection);
  }

  /// Removes existing connection.
  ///
  /// Do not use it if you are not sure what you do. This is called eg. in [removeLink] function.
  removeConnection(int connectionId) {
    connections.removeWhere((conn) => conn.connectionId == connectionId);
  }

  /// Sets the component's parent.
  ///
  /// It's not possible to make a parent-child loop. (its ancestor cannot be its child)
  ///
  /// You should use it only with [addChild] on the parent's component.
  setParent(int parentId) {
    this.parentId = parentId;
  }

  /// Removes parent's id from this component data.
  ///
  /// You should use it only with [removeChild] on the parent's component.
  removeParent() {
    parentId = null;
  }

  /// Sets the component's parent.
  ///
  /// It's not possible to make a parent-child loop. (its ancestor cannot be its child)
  ///
  /// You should use it only with [setParent] on the child's component.
  addChild(int childId) {
    childrenIds.add(childId);
  }

  /// Removes child's id from children.
  ///
  /// You should use it only with [removeParent] on the child's component.
  removeChild(int childId) {
    childrenIds.remove(childId);
  }

  @override
  String toString() {
    return 'Component data ($id)';
  }

  String? dataHash;
  ComponentFractal.fromMap(Map<String, dynamic> m)
      :
        //minSize = SizeF(json['min_size'][0], json['min_size'][1]),
        color = m['color'] != null ? Color.hex(m['color']) : defaultColor,
        //zOrder = 0,
        super.fromMap(m)
  //.data = EventFractal.controller.request(dataId),
  //; decodeCustomComponentFractal?.call(json['dynamic_data'])
  {
    print(m['data']);
    dataHash = m['data'];
    if (dataHash is String) {
      EventFractal.request(dataHash!).then((fractal) {
        data = fractal;
        notifyListeners();
      });
    }
    //todo make connections work
    /*
    childrenIds.addAll(
      (json['children_ids'] as List).map((id) => id as int).toList(),
    );
    connections.addAll(
      (json['connections'] as List).map(
        (connectionJson) => Connection.fromJson(connectionJson),
      ),
    );
    */
  }

  final link = Writable();

  @override
  onWrite(f) {
    switch (f.attr) {
      case 'link':
        link.value = f;
    }
  }
}
