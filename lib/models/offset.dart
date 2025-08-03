import 'dart:math';

import 'package:fractal/models/event.dart';

import 'position.dart';
import 'size.dart';

class OffsetBaseF {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  ///
  /// The first argument sets the horizontal component, and the second the
  /// vertical component.
  const OffsetBaseF(this._dx, this._dy);

  static final zero = OffsetBaseF(0, 0);

  Future<EventFractal> store(EventFractal fractal) async {
    return EventFractal();
  }

  final double _dx;
  final double _dy;

  /// Returns true if either component is [double.infinity], and false if both
  /// are finite (or negative infinity, or NaN).
  ///
  /// This is different than comparing for equality with an instance that has
  /// _both_ components set to [double.infinity].
  ///
  /// See also:
  ///
  ///  * [isFinite], which is true if both components are finite (and not NaN).
  bool get isInfinite => _dx >= double.infinity || _dy >= double.infinity;

  /// Whether both components are finite (neither infinite nor NaN).
  ///
  /// See also:
  ///
  ///  * [isInfinite], which returns true if either component is equal to
  ///    positive infinity.
  bool get isFinite => _dx.isFinite && _dy.isFinite;

  /// Less-than operator. Compares an [Offset] or [Size] to another [Offset] or
  /// [Size], and returns true if both the horizontal and vertical values of the
  /// left-hand-side operand are smaller than the horizontal and vertical values
  /// of the right-hand-side operand respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator <(OffsetBaseF other) => _dx < other._dx && _dy < other._dy;

  /// Less-than-or-equal-to operator. Compares an [Offset] or [Size] to another
  /// [Offset] or [Size], and returns true if both the horizontal and vertical
  /// values of the left-hand-side operand are smaller than or equal to the
  /// horizontal and vertical values of the right-hand-side operand
  /// respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator <=(OffsetBaseF other) => _dx <= other._dx && _dy <= other._dy;

  /// Greater-than operator. Compares an [Offset] or [Size] to another [Offset]
  /// or [Size], and returns true if both the horizontal and vertical values of
  /// the left-hand-side operand are bigger than the horizontal and vertical
  /// values of the right-hand-side operand respectively. Returns false
  /// otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator >(OffsetBaseF other) => _dx > other._dx && _dy > other._dy;

  /// Greater-than-or-equal-to operator. Compares an [Offset] or [Size] to
  /// another [Offset] or [Size], and returns true if both the horizontal and
  /// vertical values of the left-hand-side operand are bigger than or equal to
  /// the horizontal and vertical values of the right-hand-side operand
  /// respectively. Returns false otherwise.
  ///
  /// This is a partial ordering. It is possible for two values to be neither
  /// less, nor greater than, nor equal to, another.
  bool operator >=(OffsetBaseF other) => _dx >= other._dx && _dy >= other._dy;

  /// Equality operator. Compares an [Offset] or [Size] to another [Offset] or
  /// [Size], and returns true if the horizontal and vertical values of the
  /// left-hand-side operand are equal to the horizontal and vertical values of
  /// the right-hand-side operand respectively. Returns false otherwise.
  @override
  bool operator ==(Object other) {
    return other is OffsetBaseF && other._dx == _dx && other._dy == _dy;
  }

  @override
  int get hashCode => Object.hash(_dx, _dy);

  @override
  String toString() =>
      'OffsetBase(${_dx.toStringAsFixed(1)}, ${_dy.toStringAsFixed(1)})';
}

class OffsetF extends OffsetBaseF {
  final double z;
  static const zero = OffsetF();
  const OffsetF([super.dx = 0, super.dy = 0, this.z = 1]);
  double get distance => sqrt(dx * dx + dy * dy);

  @override
  Future<PositionFractal> store(fractal) async {
    final f = PositionFractal(
      value: this,
      to: fractal,
    );
    await f.synch();
    return f;
  }

  /// The x component of the offset.
  ///
  /// The y component is given by [dy].
  double get dx => _dx;

  /// The y component of the offset.
  ///
  /// The x component is given by [dx].
  double get dy => _dy;

  /// The x component of the offset.
  ///
  /// The y component is given by [dy].
  double get x => _dx;

  /// The y component of the offset.
  ///
  /// The x component is given by [dx].
  double get y => _dy;

  OffsetF operator -() => OffsetF(-x, -y);

  /// Binary subtraction operator.
  ///
  /// Returns an OffsetF whose [x] value is the left-hand-side operand's [x]
  /// minus the right-hand-side operand's [x] and whose [y] value is the
  /// left-hand-side operand's [y] minus the right-hand-side operand's [y].
  ///
  /// See also [translate].
  OffsetF operator -(OffsetF other) => OffsetF(x - other.x, y - other.y);

  /// Binary addition operator.
  ///
  /// Returns an OffsetF whose [x] value is the sum of the [x] values of the
  /// two operands, and whose [y] value is the sum of the [y] values of the
  /// two operands.
  ///
  /// See also [translate].
  OffsetF operator +(OffsetF other) => OffsetF(x + other.x, y + other.y);

  /// Multiplication operator.
  ///
  /// Returns an OffsetF whose coordinates are the coordinates of the
  /// left-hand-side operand (an OffsetF) multiplied by the scalar
  /// right-hand-side operand (a double).
  ///
  /// See also [scale].
  OffsetF operator *(double operand) => OffsetF(x * operand, y * operand);

  /// Division operator.
  ///
  /// Returns an OffsetF whose coordinates are the coordinates of the
  /// left-hand-side operand (an OffsetF) divided by the scalar right-hand-side
  /// operand (a double).
  ///
  /// See also [scale].
  OffsetF operator /(double operand) => OffsetF(x / operand, y / operand);

  /// Integer (truncating) division operator.
  ///
  /// Returns an OffsetF whose coordinates are the coordinates of the
  /// left-hand-side operand (an OffsetF) divided by the scalar right-hand-side
  /// operand (a double), rounded towards zero.
  OffsetF operator ~/(double operand) =>
      OffsetF((x ~/ operand).toDouble(), (y ~/ operand).toDouble());

  /// Modulo (remainder) operator.
  ///
  /// Returns an OffsetF whose coordinates are the remainder of dividing the
  /// coordinates of the left-hand-side operand (an OffsetF) by the scalar
  /// right-hand-side operand (a double).
  OffsetF operator %(double operand) => OffsetF(x % operand, y % operand);

  /// Rectangle constructor operator.
  ///
  /// Combines an [OffsetF] and a [Size] to form a [Rect] whose top-left
  /// coordinate is the point given by adding this OffsetF, the left-hand-side
  /// operand, to the origin, and whose size is the right-hand-side operand.
  ///
  /// ```dart
  /// Rect myRect = OffsetF.zero & const Size(100.0, 100.0);
  /// // same as: Rect.fromLTWH(0.0, 0.0, 100.0, 100.0)
  /// ```
  //Rect operator &(Size other) => Rect.fromLTWH(x, y, other.width, other.height);
}

class SizeF extends OffsetBaseF {
  double get width => _dx;
  double get height => _dy;

  static const zero = SizeF(0, 0);

  const SizeF(super.width, super.height);

  @override
  Future<SizeFractal> store(fractal) async {
    final f = SizeFractal(
      value: this,
      to: fractal,
    );
    await f.synch();
    return f;
  }

  @override
  String toString() {
    return 'SizeF{width: $width, height: $height}';
  }

  /// Binary addition operator for adding an [Offset] to a [Size].
  ///
  /// Returns a [Size] whose [width] is the sum of the [width] of the
  /// left-hand-side operand, a [Size], and the [Offset.dx] dimension of the
  /// right-hand-side operand, an [Offset], and whose [height] is the sum of the
  /// [height] of the left-hand-side operand and the [Offset.dy] dimension of
  /// the right-hand-side operand.
  SizeF operator +(OffsetBaseF other) => SizeF(
        width + other._dx,
        height + other._dy,
      );

  /// Multiplication operator.
  ///
  /// Returns a [Size] whose dimensions are the dimensions of the left-hand-side
  /// operand (a [Size]) multiplied by the scalar right-hand-side operand (a
  /// [double]).
  SizeF operator *(double operand) => SizeF(width * operand, height * operand);

  /// Division operator.
  ///
  /// Returns a [Size] whose dimensions are the dimensions of the left-hand-side
  /// operand (a [Size]) divided by the scalar right-hand-side operand (a
  /// [double]).
  SizeF operator /(double operand) => SizeF(width / operand, height / operand);

  /// Integer (truncating) division operator.
  ///
  /// Returns a [Size] whose dimensions are the dimensions of the left-hand-side
  /// operand (a [Size]) divided by the scalar right-hand-side operand (a
  /// [double]), rounded towards zero.
  SizeF operator ~/(double operand) =>
      SizeF((width ~/ operand).toDouble(), (height ~/ operand).toDouble());

  /// Modulo (remainder) operator.
  ///
  /// Returns a [Size] whose dimensions are the remainder of dividing the
  /// left-hand-side operand (a [Size]) by the scalar right-hand-side operand (a
  /// [double]).
  SizeF operator %(double operand) => SizeF(width % operand, height % operand);
  OffsetF center(OffsetF origin) =>
      OffsetF(origin.dx + width / 2.0, origin.dy + height / 2.0);

  /// Compares two Sizes for equality.
  // We don't compare the runtimeType because of _DebugSize in the framework.
  @override
  bool operator ==(Object other) {
    return other is SizeF && other.width == width && other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, height);
}
