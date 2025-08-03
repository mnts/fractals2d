import 'dart:io';

import 'package:crypto_fractal/crypto_fractal.dart';
import 'package:fractal/access/postgres.dart';
import 'package:fractal/server.dart';
import 'package:fractals2d/apis/ai.dart';
import 'package:fractals2d/lib.dart';

void main(List<String> args) async {
  FileF.path = './';
  print(Directory.current.path);

  await DBF.initiate(
    //constructDb('fractal')
    //if (stdout.hasTerminal) {

    PostgresFDBA(
      'fractal',
      username: 'mk',
      password: 'klI1P@qxp',
    ),
  );

  //}

  await F2dScheme().init();

  CryptoFractal.init();

  FSocketAPI.cmds['ai'] = ai;

  FServer(
    port: args.isNotEmpty ? int.parse(args[0]) : 2415,
    template: template,
  );
}

FileFractal? getFile(d) {
  switch (d) {
    case FileFractal ff:
      return ff;
    case LinkFractal lf:
      if (lf.target case FileFractal ff) return ff;
  }
  return null;
}

Future<String> template(HttpRequest req) async {
  String domain = req.headers.host ?? '';

  final app = await AppFractal.fromDomain(domain);
  await app.preload();

  print('template: $domain');
  print(app.toMap());

  var node = await app.track(req.uri.path);

  print("Node: ${node.toMap()}");

  String appSrc = '/favicon.png', nodeSrc = '/favicon.png';
  FileFractal? appImg = getFile(app['image']);
  if (appImg != null) {
    await appImg.preload();
    appSrc = '${appImg.uri}';
  }

  if (app != node) {
    FileFractal? nodeImg = getFile(node['image']);
    if (nodeImg != null) {
      await nodeImg.preload();
      nodeSrc = '${nodeImg.uri}';
    }
  }

  return '''
<!DOCTYPE html>
<html>
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="${node.description}">

  <meta property="og:title" content="${node.display}">
  <meta property="og:description" content="${node.description}">
  <meta property="og:image" content="$nodeSrc">
  <meta property="og:type" content="website">

  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="${node.display}">
  <meta name="twitter:description" content="${node.description}">
  <meta name="twitter:image" content="$nodeSrc">

  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="${app.display}">
  <link rel="apple-touch-icon" href="$appSrc">

  <link rel="icon" type="image/png" href="$appSrc"/>

  <title>${node.display}</title>
  <link rel="manifest" href="/manifest.json">
  <link rel="stylesheet" href="/init.css">
  <style>
    body:not([flt-embedding]):before {background-image: url('$appSrc');}
  </style>
</head>
<body>
  <script src="/flutter_bootstrap.js" async></script>
  <script type="module">
    import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.min.js";
    window.ethers = ethers
  </script>
</body>
</html>
''';
}
