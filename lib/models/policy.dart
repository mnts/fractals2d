import 'package:fractals2d/mixins/canvas.dart';
import 'package:fractals2d/models/state.dart';
import 'package:fractal/index.dart';

class BasePolicySet extends FChangeNotifier {
  final CanvasMix model;
  CanvasState get state => model.cState;

  BasePolicySet({required this.model}) {}

  /*
  /// Allows you to read all data from diagram/canvas model.
  late CanvasReader canvasReader;

  /// Allows you to change diagram/canvas model data.
  late CanvasWriter canvasWriter;

  /// Initialize policy in [DiagramEditorContext].
  initializePolicy(CanvasReader canvasReader, CanvasWriter canvasWriter) {
    this.canvasReader = canvasReader;
    this.canvasWriter = canvasWriter;
  }
  */
}
