import 'package:fractal/fractal.dart';
import 'package:position_fractal/fractals/offset.dart';
import 'package:signed_fractal/models/event.dart';

import '../controllers/link.dart';
import 'link_style.dart';

/// Class that carries all link data.
class LinkFractal extends EventFractal {
  static final controller = LinksCtrl(
    make: (d) => switch (d) {
      MP() => LinkFractal.fromMap(d),
      Object() || null => throw ('wrong event type')
    },
    extend: EventFractal.controller,
  );

  @override
  LinksCtrl get ctrl => controller;

  static int maxId = 0;

  /// Id of source component.
  final int sourceComponentId;

  /// Id of target component.
  final int targetComponentId;

  static const mainLinkStyle = LinkStyle();
  LinkStyle get linkStyle => mainLinkStyle;

  /// Points from which the link is drawn on canvas.
  ///
  /// First and last points lay on the two components which are connected by this link.
  List<OffsetF> linkPoints = [];

  /// Defines the visibility of link's joints.
  bool areJointsVisible = false;

  /// Dynamic data for you to define your own data for this link.
  dynamic data;

  /// Represents data of a link/connection in the model.
  LinkFractal({
    super.id,
    this.linkPoints = const [],
    required this.sourceComponentId,
    required this.targetComponentId,
    this.data,
  }); // : linkStyle = linkStyle ?? LinkStyle();

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
  ///
  /// The points lie on the source and target components.
  setEndpoints(OffsetF start, OffsetF end) {
    linkPoints[0] = start;
    linkPoints[linkPoints.length - 1] = end;
    notifyListeners();
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

  LinkFractal.fromMap(
    Map<String, dynamic> json, {
    Function(Map<String, dynamic> json)? decodeCustomLinkData,
  })  : sourceComponentId = json['source_component_id'],
        targetComponentId = json['target_component_id'],
        data = decodeCustomLinkData?.call(json['dynamic_data']) {
    id = json['id'];
  }

  @override
  MP toMap() => {
        'id': id,
        'source_component_id': sourceComponentId,
        'target_component_id': targetComponentId,
        'link_style': linkStyle,
        'link_points': linkPoints.map((point) => [point.dx, point.dy]).toList(),
        'dynamic_data': data?.toJson(),
        ...super.toMap(),
      };
}
