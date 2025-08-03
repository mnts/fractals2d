import 'dart:convert';
import 'dart:typed_data';
import '../lib.dart';

extension TellComponentExt on ComponentFractal {
  Future spark(SparkF spark, {LinkFractal? link}) async {
    print(spark.map);

    if (link != null) {
      spark.pulse.passed.add(link);
    }

    switch (shape) {
      case ShapeF.oval:
        sparkOval(spark);
      case ShapeF.bean:
        sparkBean(spark);
      default:
        final methodName = link?.resolve('method');

        switch (methodName) {
          case 'replace':
            if (spark.map['item'] case EventFractal newEv) {
              item = newEv;
            }
            spread(spark);
            return;
        }

        print('item ${item?.hash}');
        switch (item) {
          case FileFractal fileF:
            final bytes = switch (spark.map['data']) {
              Uint8List data => data,
              FileF file => file.bytes,
              //to json string
              List data => utf8.encode(jsonEncode(data)),
              Map data => utf8.encode(jsonEncode(data)),
              String data => utf8.encode(data),
              _ => null,
            };

            if (bytes != null) {
              fileF.write(bytes);
            }
            spread(spark.re(spark.map));
          case Attr attr:
            final re = spark.re(
              {attr.name: spark.map},
            );
            spread(re);
          case NodeFractal dNode:
            print('node ${dNode.toMap()}');
            switch (dNode.inter) {
              case 'node':
                final mk = MakeF({
                  ...spark.map,
                  'to': dNode,
                });
                print('make: $mk');

                final c = FractalCtrl.storage[mk.map['type']];
                switch (c) {
                  case FileCtrl fc:
                    mk.map['kind'] = FKind.file.index;
                }

                if (c case EventsCtrl evc) {
                  final f = await evc.put(mk);
                  print(f.toMap());
                  await f.synch();
                  spark.pulse.collect?.call(f);
                  spread(spark.re({'item': f}));
                }
            }

          /*
            switch (await dataNode.tell(spark)) {
              case SparkF reSpark:
                spread(reSpark);
            }
          */

          case EventFractal evf:
            final telling = evf.tell(spark);
            telling;
            spread(await telling);
          case null when content.isNotEmpty:
            spread(spark.re(
              await throughContent(spark.map),
            ));
          case null:
            final reSpark = digest(spark);
            spread(reSpark);
        }
      /*
        final fName = '${this['function']}';
        final fn = Fractals2d.functions[fName];
        if (fn == null) return;
        final re = await fn(spark);
        */
    }
    return true;
  }

  sparkOval(SparkF spark) {
    final output = spark.pulse.outputBy[this] ??= {};
    output.addAll(spark.map);

    if (linksIn
        .where(
          (link) => link.to is ComponentFractal,
        )
        .every(
          (linkIn) => spark.pulse.passed.contains(linkIn),
        )) {
      final reSpark = SparkF(
        pulse: spark.pulse,
        map: output,
      );

      print('passed $reSpark');
      spread(reSpark);
    }
    return;
  }

  sparkBean(SparkF spark) {
    final attr = content;
    final map = {...spark.map};
    if (spark.pulse.by case Rewritable rew) {
      if (spark.map case NodeFractal node) {
        return;
      }
      final value = spark.map['value'];
      if (value is String) {
        rew.write(attr, value);
      } else {
        map['value'] = rew[attr];
      }

      final reSpark = SparkF(
        pulse: spark.pulse,
        map: map,
      );

      spread(reSpark);
    }
  }
}
