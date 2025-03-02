import 'package:color/color.dart';

enum ArrowType {
  none, // No arrow/shape
  arrow, // Simple triangle arrow
  pointedArrow, // Sharper, more pointed arrow
  circle, // Filled circle
  centerCircle, // Circle with empty center (ring)
  semiCircle, // Half circle
  square, // Filled square
  diamond, // Diamond/rhombus shape
  triangle, // Filled triangle
  star, // Star shape
  hexagon, // Six-sided polygon
  pentagon, // Five-sided polygon
}

enum LineType {
  solid, // Continuous line
  dashed, // Line with gaps
  dotted, // Line with dots
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
    this.arrowType = ArrowType.arrow,
    this.backArrowType = ArrowType.none,
    this.arrowSize = 8,
    this.backArrowSize = 6,
    this.lineWidth = 3,
    this.color = const Color.rgb(20, 20, 180),
  })  : assert(lineWidth > 0),
        assert(arrowSize > 0);

  double getEndShortening(ArrowType arrowType) {
    switch (arrowType) {
      case ArrowType.none:
        return 0; // No shape, no shortening
      case ArrowType.arrow:
        return arrowSize * 2; // Tip at endpoint, base behind
      case ArrowType.pointedArrow:
        return arrowSize * 3; // Tip at endpoint, longer base behind
      case ArrowType.circle:
        return arrowSize; // Circle center behind, edge at endpoint
      case ArrowType.centerCircle:
        return -arrowSize; // Center at endpoint, edge ahead
      case ArrowType.semiCircle:
        return arrowSize; // Center behind, flat edge at endpoint
      case ArrowType.square:
        return arrowSize; // Center behind, edge at endpoint
      case ArrowType.diamond:
        return arrowSize; // Center behind, point at endpoint
      case ArrowType.triangle:
        return arrowSize * 2; // Tip at endpoint, base behind
      case ArrowType.star:
        return arrowSize; // Center behind, outer point at endpoint
      case ArrowType.hexagon:
        return arrowSize; // Center behind, edge at endpoint
      case ArrowType.pentagon:
        return arrowSize; // Center behind, edge at endpoint
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
