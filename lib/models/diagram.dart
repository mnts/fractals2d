import 'component.dart';
import 'link_data.dart';

class DiagramData {
  final List<ComponentFractal> components;
  final List<LinkFractal> links;

  /// Contains list of all components and list of all links of the diagram
  DiagramData({
    required this.components,
    required this.links,
  });
}
