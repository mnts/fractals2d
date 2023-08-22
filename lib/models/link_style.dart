import 'package:color/color.dart';

enum ArrowType {
  none,
  arrow,
  pointedArrow,
  circle,
  centerCircle,
  semiCircle,
}

enum LineType {
  solid,
  dashed,
  dotted,
}

class LinkStyle {
  /// Defines the design of the link's line.
  ///
  /// It can be [LineType.solid], [LineType.dashed] or [LineType.dotted].
  final LineType lineType;

  /// Defines the design of the link's front arrowhead.
  ///
  /// There are several designs, choose from [ArrowType] enum.
  final ArrowType arrowType;

  /// Defines the design of the link's back arrowhead.
  ///
  /// There are several designs, choose from [ArrowType] enum.
  final ArrowType backArrowType;

  /// Defines the size of the link's front arrowhead.
  final double arrowSize;

  /// Defines the size of the link's back arrowhead.
  final double backArrowSize;

  /// Defines the width of the link's line.
  final double lineWidth;

  /// Defines the color of the link's line and both arrowheads.
  final Color color;

  /// Defines a visual design of a link on the canvas.
  const LinkStyle({
    this.lineType = LineType.solid,
    this.arrowType = ArrowType.none,
    this.backArrowType = ArrowType.none,
    this.arrowSize = 8,
    this.backArrowSize = 8,
    this.lineWidth = 2,
    this.color = const Color.rgb(0, 0, 0),
  })  : assert(lineWidth > 0),
        assert(arrowSize > 0);

  double getEndShortening(ArrowType arrowType) {
    double eps = 0.05;
    switch (arrowType) {
      case ArrowType.none:
        return 0;
      case ArrowType.arrow:
        return arrowSize - eps;
      case ArrowType.pointedArrow:
        return (arrowSize * 2) - eps;
      case ArrowType.circle:
        return arrowSize - eps;
      case ArrowType.centerCircle:
        return 0;
      case ArrowType.semiCircle:
        return arrowSize - eps;
    }
  }

  LinkStyle.fromJson(Map<String, dynamic> json)
      : lineType = LineType.values[json['line_type']],
        arrowType = ArrowType.values[json['arrow_type']],
        backArrowType = ArrowType.values[json['back_arrow_type']],
        arrowSize = json['arrow_size'],
        backArrowSize = json['back_arrow_size'],
        lineWidth = json['line_width'],
        color = Color.hex((json['color']));

  Map<String, dynamic> toJson() => {
        'line_type': lineType.index,
        'arrow_type': arrowType.index,
        'back_arrow_type': backArrowType.index,
        'arrow_size': arrowSize,
        'back_arrow_size': backArrowSize,
        'line_width': lineWidth,
        'color': color.toString().split('(0x')[1].split(')')[0],
      };
}
