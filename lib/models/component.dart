import 'package:app_fractal/index.dart';
import 'package:color/color.dart';
import 'package:fractals2d/models/link_data.dart';
import 'package:fractals2d/models/link_style.dart';
import 'package:position_fractal/fractals/index.dart';
import 'package:position_fractal/props/position.dart';
import '../controllers/component.dart';
import '../lib.dart';

class ComponentFractal<T extends EventFractal> extends EventFractal
    with Rewritable, InteractiveFractal, FlowF<T>, FilterF<T> {
  static final controller = ComponentsCtrl(
    extend: EventFractal.controller,
    name: 'component',
    make: (d) => switch (d) {
      MP() => ComponentFractal.fromMap(d),
      null || Object() => throw ('wrong event type'),
    },
    attributes: [
      Attr(name: 'z', format: FormatF.integer),
      Attr(
        name: 'data',
        format: FormatF.reference,
        canNull: true,
      ),
    ],
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
  get eventsSource => EventFractal.controller;

  @override
  move() {
    refreshLinks();
  }

  @override
  consume(event) {
    switch (event) {
      case (PositionFractal f):
        position.value = f.value;
      case (SizeFractal f):
        size.value = f.value;
    }
    refreshLinks();
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
  //final List<Connection> connections = [];

  /// Dynamic data for you to define your own data for this component.

  /// Represents data of a component in the model.
  static const defaultColor = Color.rgb(255, 255, 255);

  EventFractal? data;

  final linksIn = <LinkFractal>[];
  final linksOut = <LinkFractal>[];
  refreshLinks() {
    final links = [...linksIn, ...linksOut];
    for (final link in links) {
      link.refreshEndPoints();
    }
  }

  bool get isPlaced => !(position.value.x == 0 ||
      position.value.y == 0 ||
      size.value.width == 0 ||
      size.value.height == 0);

  addLink(LinkFractal link) {
    if ((link.source) == this && !linksOut.contains(link)) {
      linksOut.add(link);
    }
    if ((link.target) == this && !linksIn.contains(link)) {
      linksIn.add(link);
    }
    notifyListeners();
  }

  bool _initiated = false;
  @override
  Future<bool> initiate() async {
    if (_initiated) return true;
    _initiated = true;
    //sub.list.forEach(receive);
    //sub.listen(receive);
    await refresh();

    /*
    EventFractal(
      to: deviceInteraction,
    ).synch();
    */

    if (!onlyLocal) {
      NetworkFractal.out?.sink({
        'cmd': 'subscribe',
        'hash': hash,
      });
    }

    return super.initiate();
  }

  @override
  preload([type]) async {
    //myInteraction;
    await super.preload(type);
    //if (type == 'node') nodes;

    await initiate();
    return 1;
  }

  OffsetF getPoint([int x = 0, int y = 0]) {
    return position.value +
        OffsetF(
          size.value.width * ((x + 1) / 2),
          size.value.height * ((y + 1) / 2),
        );
  }

  OffsetF getLinkEndpoint(
    OffsetF targetPoint,
  ) {
    var pointPosition =
        targetPoint - (position.value + size.value.center(OffsetF.zero));
    pointPosition = OffsetF(
      pointPosition.dx / size.width,
      pointPosition.dy / size.height,
    );

    switch (type) {
      case 'oval':
        final pointAlignment = pointPosition / pointPosition.distance;
        return OffsetF(pointAlignment.dx, pointAlignment.dy);
      case 'crystal':
        OffsetF pointAlignment =
            pointPosition / (pointPosition.dx.abs() + pointPosition.dy.abs());

        return OffsetF(pointAlignment.dx, pointAlignment.dy);

      default:
        OffsetF pointAlignment =
            (pointPosition.dx.abs() >= pointPosition.dy.abs())
                ? OffsetF(
                    pointPosition.dx / pointPosition.dx.abs(),
                    pointPosition.dy / pointPosition.dx.abs(),
                  )
                : OffsetF(
                    pointPosition.dx / pointPosition.dy.abs(),
                    pointPosition.dy / pointPosition.dy.abs(),
                  );

        final r = position.value +
            OffsetF(
              size.value.width * ((pointAlignment.dx + 1) / 2),
              size.value.height * ((pointAlignment.dy + 1) / 2),
            );
        return OffsetF(r.x, r.y);
    }
  }

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
  }

  final tansformers = TransformerPreprocessor({});
  SparkF digest(SparkF spark) {
    final m = Transformer(
      spark.map,
      tansformers.preprocessed,
    ).digest();

    for (var link in linksIn.where(
      (l) => l.linkStyle.arrowType == ArrowType.circle,
    )) {
      if (link['input'] case String input) {
        m[input] = link.target.m.writtenMap;
      }
    }

    print(m);

    return SparkF(pulse: spark.pulse, map: m);
  }

  @override
  Future tell(m) async {
    switch (m) {
      case InteractionFractal f:
        final map = f.m.writtenMap;
        final re = switch (this.data) {
          EventsCtrl ctrl => await ctrl.put(map),
          CatalogFractal cf => cf.input(f) ? f : null,
          EventFractal ev => ev.tell(map),
          _ => null,
        };
      case SparkF spark:
        switch (data) {
          case NodeFractal dataNode:
            switch (await dataNode.tell(spark)) {
              case SparkF reSpark:
                spread(reSpark);
            }
          case null:
            final reSpark = digest(spark);
            spread(reSpark);
        }
        /*
        final fName = '${this['function']}';
        final fn = Fractals2d.functions[fName];
        if (fn == null) return;
        final re = await fn(spark);
        */

        return;
      case MP m:
        if (data case CatalogFractal filter) {
          var ctrl = filter.source as EventsCtrl?;
          ctrl ??= NodeFractal.controller;
          m['type'] = ctrl.name;

          final f = await ctrl.put(m);
          //if (f.id != 0)
          filter.input(f);

          return;
        }

        final my = collect();

        switch (my) {
          case MP myM:
            for (final kv in myM.entries) {
              final eq = m[kv.key];
              if (kv.value[0] == '=' &&
                  (eq == null || eq != '${kv.value}'.substring(1))) {
                return;
              }
              m[kv.key] = kv.value;
            }

            submit(m);
        }
        _:
        super.tell(m);
    }
  }

  @override
  spread(thing) async {
    for (var link in linksOut.where(
      (l) => l.linkStyle.arrowType == ArrowType.arrow,
    )) {
      link.target.tell(thing);
    }
  }

  submit([MP? m]) async {
    final f = m ?? collect();
    for (final link in linksOut) {
      link.target.tell(f);
    }
  }

  collect() {
    switch (data) {
      case NodeFractal node:
        final MP m = {};
        for (final ev in node.sorted.value) {
          switch (ev) {
            case NodeFractal n:
              final val = this[n.name];
              if (val != null) m[n.name] = val;
          }
        }
        if (m.isNotEmpty) return m;
    }
  }

  //get hashData => [...super.hashData];

  @override
  operator [](String key) => switch (key) {
        'data' => data?.hash ?? '',
        'z' => 0,
        _ => m[key]?.content ?? super[key],
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

  removeConnection(LinkFractal link) {
    linksIn.remove(link);
    linksOut.remove(link);
  }

  /*
  /// Adds new connection to this component.
  ///
  /// Do not use it if you are not sure what you do. This is called in [connectTwoComponents] function.
  addConnection(Connection connection) {
    connections.add(connection);tansformers
  /// Do not use it if you are not sure what you do. This is called eg. in [removeLink] function.

  */
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

  ComponentFractal.fromMap(Map<String, dynamic> m)
      :
        //minSize = SizeF(json['min_size'][0], json['min_size'][1]),
        color = m['color'] != null ? Color.hex(m['color']) : defaultColor,
        //zOrder = 0,
        data = m['data'],
        super.fromMap(m)
  //.data = EventFractal.controller.request(dataId),
  //; decodeCustomComponentFractal?.call(json['dynamic_data'])
  {
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
  onWrite(f) async {
    final ok = await super.onWrite(f);
    if (ok) {
      switch (f.attr) {
        case 'link':
          link.value = f;
        default:
          tansformers.update(f.attr, f.content);
      }
    }
    return ok;
  }
}
