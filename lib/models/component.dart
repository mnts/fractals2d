import 'dart:async';
import 'package:color/color.dart';
import 'package:fractal/afi/chat/internal.dart';
import '../lib.dart';

class ComponentFractal<T extends EventFractal> extends EventFractal
    with
        ExtendableF,
        InteractiveFractal,
        FlowF<T>,
        FilterF<T>,
        MF<String, T>,
        MFE<T>,
        Rewritable<T>,
        HierarchyF<T>,
        WithNotifications,
        WithLinksF
    implements ContainerF {
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
        name: 'item',
        format: FormatF.reference,
        canNull: true,
      ),
      Attr(
        name: 'shape',
        format: FormatF.integer,
        def: '0',
      ),
      ExtendableF.attr,
    ],
  );

  @override
  ComponentsCtrl get ctrl => controller;

  @override
  EventFractal? item;

  @override
  get filters => [
        ...super.filters,
        {
          'to': id,
          'type': 'link',
        },
        {
          'to': id,
          'type': ['size', 'position'],
          '\$': 'type',
        },
      ];
  Color color;

  Color borderColor = const Color.rgb(55, 55, 55);
  double borderWidth = 0;
  double textSize = 18;

  var size = SizeFractal(
    value: SizeF.zero,
  );
  PositionFractal position = PositionFractal(
    value: OffsetF.zero,
  );

  final ShapeF shape;

  InteractionFractal? interaction;
  late final ai = InternalApiService(node: this);
  /*
  @override
  move() {
    refreshLinks();
  }\
  */

  int get topZ => switch (to) {
        CanvasMix cm => cm.topZ++,
        _ => 0,
      };
  int z = 0;

  static const defaultColor = Color.rgb(255, 255, 255);

  bool _initiated = false;
  @override
  Future<bool> initiate() async {
    if (_initiated) return true;
    _initiated = true;

    await refresh();

    notifyInLinks();

    subscribe();

    return super.initiate();
  }

  @override
  preload([type]) async {
    //myInteraction;
    print('comp@ preload $hash');
    await super.preload(type);
    //if (type == 'node') nodes;
    print('comp@ preloaded $id');

    await initiate();
    return 1;
  }

  //static final defaultSize = SizeF(160, 120);

  ComponentFractal({
    super.id,
    SizeF? size,
    super.to,
    super.content,
    this.color = defaultColor,
    this.item,
    this.shape = ShapeF.rect,
    NodeFractal? extend,
  }) {
    z = topZ;

    this.extend = extend;
    listenExtended();
  }

  final _timed = TimedF();
  //late final positions = db.select(DB.main.positions).watch();
  move(OffsetF offset) {
    position.value = offset;
    if (offset case OffsetF offset) {
      if (offset.x == 0 && offset.y == 0) return;
    }
    notifyListeners();
    _timed.hold(() async {
      //if (to case CanvasMix c when c.dontStore) return;
      print('resized $offset');
      PositionFractal(
        value: offset,
        to: this,
      ).synch();
    });
  }

  resize(SizeF offset) {
    size.value = offset;
    if (offset case OffsetF offset) {
      if (offset.x == 0 && offset.y == 0) return;
    }
    notifyListeners();
    _timed.hold(() async {
      //if (to case CanvasMix c when c.dontStore) return;
      SizeFractal(
        value: offset,
        to: this,
      ).synch();
    });
  }

  final transformers = TransformerPreprocessor({});
  SparkF digest(SparkF spark) {
    final m = Transformer(
      spark.map,
      transformers.preprocessed,
    ).digest();

    //print(m);

    return spark.re(m);
  }

  @override
  get uis => ['button', 'input'];

  final compose = {};

  @override
  Future tell(m, {LinkFractal? link}) async {
    try {
      switch (m) {
        case InteractionFractal f:
          final map = f.writtenMap;
          final re = switch (item) {
            EventsCtrl ctrl => await ctrl.put(map),
            CatalogFractal cf => cf.input(f) ? f : null,
            EventFractal ev => ev.tell(map),
            _ => null,
          };
        case SparkF s:
          sparks
            ..value.add(s)
            ..notifyListeners();
          return await spark(s, link: link);
        case MP m:
          if (item case CatalogFractal filter) {
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
      }

      return true;
    } catch (e) {
      error(e.toString());
    } finally {
      sparks
        ..value.remove(m)
        ..notifyListeners();
    }
  }

  final sparks = Frac<List<SparkF>>([]);
  @override
  Future spread(thing) async {
    await preload();
    final rqs = <Future>[
      ...linksOut.map(
        (link) => link.target.tell(
          thing,
          link: link,
        ),
        //rqs.add(rf);
      ),
    ];
    return Future.wait(
      rqs,
      eagerError: true,
    );
  }

  submit([MP? m]) async {
    final f = m ?? collect();
    for (final link in linksOut) {
      link.target.tell(f);
    }
  }

  collect() {
    switch (item) {
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
  resolve(key) => sub[key]?.content ?? super.resolve(key);

  @override
  operator [](key) => switch (key) {
        'item' => item,
        'z' => z,
        'shape' => shape.index,
        _ => super[key] ?? sub[key],
      };

  bool isHighlighted = false;

  @override
  String toString() {
    return 'Component($id)';
  }

  ComponentFractal.fromMap(d)
      :
        //minSize = SizeF(json['min_size'][0], json['min_size'][1]),
        color = d['color'] != null ? Color.hex(d['color']) : defaultColor,
        item = d['item'],
        shape = ShapeF.values[d['shape'] ?? 0],
        super.fromMap(d)
  //.data = EventFractal.controller.request(dataId),
  //; decodeCustomComponentFractal?.call(json['dynamic_data'])
  {
    z = switch (d['z']) {
      int i when i > 0 => i,
      _ => topZ,
    };
//size.value = defaultSize;
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

  //final link = Writable();

  @override
  String get display => '${shape.name} $hash';

  refreshCanvas() {
    if (to case CanvasMix c) {
      c.notifyListeners();
    }
  }

  /* 
  bool _isCoord(T f) => f is PositionFractal || f is SizeFractal;

  @override
  input(T f) {
    if (_isCoord(f)) {
      list.removeWhere(
        (lf) => _isCoord(lf) && lf.createdAt < f.createdAt,
      );
    }

    super.input(f);
  }
  */

  @override
  get list => [
        ...sub.values,
        ...linksOut.whereType<T>(),
        if (size case T s when size.value != SizeF.zero) s,
        if (position case T p when position.value != OffsetF.zero) p,
      ];

  @override
  consume(f) async {
    switch (f) {
      case (PositionFractal f):
        position = f;
        refreshCanvas();
      case (SizeFractal f):
        size = f;
        refreshCanvas();
    }

    //refreshLinks();
    switch (f.name) {
      case 'link':
      //link.value = f;
      default:
        transformers.update(f.name, f.content);
    }
    super.consume(f);

    if (f is LinkFractal) refreshCanvas();
  }
}
