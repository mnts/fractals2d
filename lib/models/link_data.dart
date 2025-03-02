import 'package:app_fractal/index.dart';
import 'package:color/color.dart';
import 'package:fractals2d/mixins/canvas.dart';
import 'package:position_fractal/fractals/offset.dart';
import '../controllers/link.dart';
import 'component.dart';
import 'link_style.dart';

/// Class that carries all link data.
class LinkFractal extends EventFractal with ExtendableF {
  static final controller = LinksCtrl(
    make: (d) => LinkFractal.fromMap(d),
    extend: EventFractal.controller,
    attributes: [
      Attr(
        name: 'target',
        format: FormatF.reference,
      ),
      Attr(
        name: 'source',
        format: FormatF.reference,
      ),
      ExtendableF.attr,
    ],
  );

  @override
  LinksCtrl get ctrl => controller;

  static int maxId = 0;

  ComponentFractal source;
  ComponentFractal target;

  static const mainLinkStyle = LinkStyle();
  LinkStyle get linkStyle => mainLinkStyle;

  /// Points from which the link is drawn on canvas.
  ///
  /// First and last points lay on the two components which are connected by this link.
  var linkPoints = <OffsetF>[];

  /// Defines the visibility of link's joints.
  bool areJointsVisible = false;

  /// Dynamic data for you to define your own data for this link.
  //dynamic data;

  /// Represents data of a link/connection in the model.
  LinkFractal({
    super.id,
    super.to,
    required this.source,
    required this.target,
    NodeFractal? extend,
    //this.data,
  }) {
    init();

    this.extend = extend;
    listenExtended();
  } // : linkStyle = linkStyle ?? LinkStyle();

  @override
  Future<bool> constructFromMap(m) async {
    if (m['extend'] case String extHash) setExtendable(extHash);
    return super.constructFromMap(m);
  }

  /// Updates this link on the canvas.
  ///
  /// Use this function if you somehow changed the link data and you want to propagate the change to canvas.
  /// Usually this is already called in most functions such as [setStart] or [insertMiddlePoint] so it's not necessary to call it again.
  ///
  /// It calls [notifyListeners] function of [ChangeNotifier].
  updateLink() {
    notifyListeners();
  }

  /// Sets the position of the first point of the link which lies on the source component.
  setStart(OffsetF start) {
    linkPoints[0] = start;
    notifyListeners();
  }

  /// Sets the position of the last point of the link which lies on the target component.
  setEnd(OffsetF end) {
    linkPoints[linkPoints.length - 1] = end;
    notifyListeners();
  }

  /// Sets the position of both first and last point of the link.
  ///import 'package:fractal/fractal.dart';

  /// The points lie on the source and target components.
  setEndpoints(OffsetF start, OffsetF end) {
    //if (linkPoints.isEmpty) {
    linkPoints = [
      start,
      //start + OffsetF(32, 0),
      //end - OffsetF(32, 0),
      end,
    ];
    /*
    } else {
      linkPoints[0] = start;
      linkPoints[max(linkPoints.length - 1, 1)] = end;
    }
    */
    if (to case CanvasMix canvas) canvas.updateCanvas();
  }

  /// Returns list of all point of the link.
  List<OffsetF> getLinkPoints() {
    return linkPoints;
  }

  /// Adds a new point to link on [point] location.
  ///
  /// [index] is an index of link's segment where you want to insert the point.
  /// Indexed from 1.
  /// When the link is a straight line you want to add a point to index 1.
  insertMiddlePoint(OffsetF position, int index) {
    assert(index > 0);
    assert(index < linkPoints.length);
    linkPoints.insert(index, position);
    notifyListeners();
  }

  /// Sets the new position ([point]) to the existing link's point.
  ///
  /// Middle points are indexed from 1.
  setMiddlePointPosition(OffsetF position, int index) {
    linkPoints[index] = position;
    notifyListeners();
  }

  /// Updates link's point position by [offset].
  ///
  /// Middle points are indexed from 1.
  moveMiddlePoint(OffsetF offset, int index) {
    linkPoints[index] += offset;
    notifyListeners();
  }

  /// Removes the point on [index]^th place from the link.
  ///
  /// Middle points are indexed from 1.
  removeMiddlePoint(int index) {
    assert(linkPoints.length > 2);
    assert(index > 0);
    assert(index < linkPoints.length - 1);
    linkPoints.removeAt(index);
    notifyListeners();
  }

  /// Updates all link's middle points position by [offset].
  moveAllMiddlePoints(OffsetF position) {
    for (int i = 1; i < linkPoints.length - 1; i++) {
      linkPoints[i] += position;
    }
  }

  /// Makes all link's joint visible.
  showJoints() {
    areJointsVisible = true;
    notifyListeners();
  }

  /// Hides all link's joint.
  hideJoints() {
    areJointsVisible = false;
    notifyListeners();
  }

  init() async {
    source.addLink(this);
    target.addLink(this);
    await refreshEndPoints();
    notifyListeners();
  }

  Future<bool> refreshEndPoints() async {
    if (!source.isPlaced || !target.isPlaced) return false;
    final sourcePoint = source.getLinkEndpoint(
      target.getPoint(),
    );
    final targetPoint = target.getLinkEndpoint(
      source.getPoint(),
    );
    setEndpoints(
      sourcePoint,
      targetPoint,
    );
    return true;
  }

  LinkFractal.fromMap(MP m)
      : target = m['target'],
        source = m['source'],
        super.fromMap(m)
  //data = decodeCustomLinkData?.call(json['dynamic_data'])
  {
    init();
  }

  var style = LinkStyle();

  @override
  notifyListeners() {
    style = LinkStyle(
      arrowType: switch (int.tryParse('${resolve('front')}')) {
        int n => ArrowType.values[n],
        _ => ArrowType.arrow,
      },
      backArrowType: switch (int.tryParse('${resolve('back')}')) {
        int n => ArrowType.values[n],
        _ => ArrowType.none,
      },
      color: Color.hex('${resolve('color') ?? '#000000'}'),
    );
    super.notifyListeners();
  }

  @override
  resolve(key) => this[key] ?? extend?[key];

  @override
  operator [](String key) => switch (key) {
        'source' => source.hash,
        'target' => target.hash,
        _ => super[key],
      };
  //'link_points': linkPoints.map((point) => [point.dx, point.dy]).toList(),
}
