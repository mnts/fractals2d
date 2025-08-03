import '../lib.dart';

extension ComponentMixFExt on ComponentFractal {
  OffsetF getPoint([int x = 0, int y = 0]) {
    return position.value +
        OffsetF(
          sized.width * ((x + 1) / 2),
          sized.height * ((y + 1) / 2),
        );
  }

  OffsetF getLinkEndpoint(
    OffsetF targetPoint,
  ) {
    var pointPosition =
        targetPoint - (position.value + sized.center(OffsetF.zero));
    pointPosition = OffsetF(
      pointPosition.dx / sized.width,
      pointPosition.dy / sized.height,
    );

    OffsetF pointAlignment = (pointPosition.dx.abs() >= pointPosition.dy.abs())
        ? OffsetF(
            pointPosition.dx / pointPosition.dx.abs(),
            pointPosition.dy / pointPosition.dx.abs(),
          )
        : OffsetF(
            pointPosition.dx / pointPosition.dy.abs(),
            pointPosition.dy / pointPosition.dy.abs(),
          );

    switch (resolve('shape')) {
      case 'oval':
        return OffsetF(pointAlignment.dx, pointAlignment.dy);
      case 'crystal':
        OffsetF pointAlignment =
            pointPosition / (pointPosition.dx.abs() + pointPosition.dy.abs());

        return OffsetF(pointAlignment.dx, pointAlignment.dy);

      default:
        final r = position.value +
            OffsetF(
              sized.width * ((pointAlignment.dx + 1) / 2),
              sized.height * ((pointAlignment.dy + 1) / 2),
            );
        return OffsetF(r.x, r.y);
    }
  }

  /*
  refreshLinks() {
    final links = [...linksIn, ...linksOut];
    for (final link in links) {
      link.refreshEndPoints();
    }
  }
  */

  void notifyInLinks() {
    for (var link in linksIn) {
      link.notifyListeners();
    }
  }

  SizeF get sized {
    var s = size.value;
    if (s == SizeF.zero) {
      s = switch (shape) {
        ShapeF.oval => const SizeF(32, 32),
        ShapeF.triE => const SizeF(48, 48),
        ShapeF.triW => const SizeF(48, 48),
        ShapeF.bean => const SizeF(96, 48),
        _ => const SizeF(200, 100),
      };
    }
    return s;
  }

  post2AI(String v) async {
    final msg = v.trim();
    if (msg.isEmpty) return;
    if (interaction == null) {
      final inter = interaction = await newInteraction;
      await inter.synch();
      notifyListeners();
    }

    final evf = EventFractal(
      content: msg,
      to: interaction,
      owner: NetworkFractal.actor,
    );
    await evf.synch();

    final stream = await interaction!.stream;
    await stream.synch();

    processAI();
  }

  static Future? processingAI;
  processAI() async {
    //await processingAI;
    final stream = await interaction!.stream;
    final msgs = ai.listMessages(stream.list);
    processingAI = ai.processConversation(
      msgs,
      () => EventFractal(
        to: interaction,
        integer: 1,
      ),
      processAI,
    );
  }

  bool get isPlaced => position.value != OffsetF.zero;
  /*
  !(position.value.x == 0 ||
      position.value.y == 0 ||
      sized.width == 0 ||
      sized.height == 0);
  */

  /// Returns Offset position on this component from [alignment].
  ///
  /// [Alignment.topLeft] returns [Offset.zero]
  ///
  /// [Alignment.center] or [Alignment(0, 0)] returns the center coordinates on this component.
  ///
  /// [Alignment.bottomRight] returns offset that is equal to size of this component.
}
