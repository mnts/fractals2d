import 'package:app_fractal/index.dart';

abstract class FTransformer {
  NodeFractal node;
  FTransformer(this.node);
  NodeFractal transform();
  static final map = <String, FTransformer Function(NodeFractal)>{
    'rewriter': (node) => RewriterFTransformer(node),
  };
}
