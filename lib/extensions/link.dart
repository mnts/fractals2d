import '../lib.dart';

extension LinkFractalExt on LinkFractal {
  static const mainLinkStyle = LinkStyle();

  LinkStyle get makeStyle => LinkStyle(
        front: resolve('icon'),
        back: resolve('back'),
        lineType: switch (int.tryParse('${resolve('line')}')) {
          int n => LineType.values[n],
          _ => LineType.round,
        },
        color: int.tryParse('${resolve('color')}'),
      );

  List<OffsetF> get endPoints {
    if (to is! ComponentFractal) throw 'not to component';
    final source = to as ComponentFractal;
    final target = this.target as ComponentFractal;
    //if (!source.isPlaced || !target.isPlaced) throw 'link not placed';
    final list = <OffsetF>[];

    list.add(
      source.getLinkEndpoint(
        target.getPoint(),
      ),
    );

    list.add(
      target.getLinkEndpoint(
        source.getPoint(),
      ),
    );

    return list;
  }

  /*
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
    if (target.to case CanvasMix canvas) canvas.updateCanvas();
  }

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
  */
}
