import 'dart:io';

import 'package:fractal/types/file.dart';
import 'package:fractal_base/index.dart';
import 'package:fractal_server/fractal_server.dart';
import 'package:fractal_socket/socket.dart';
import 'package:fractals2d/lib.dart';
import 'package:fractal/utils/random.dart';

void main(List<String> arguments) async {
  FileF.path = '../';
  await DBF.initiate();
  Fractals2d.init();

  final dir = Directory.current.path;
  print(dir);

  FServer(
    buildSocket: (name) => FSocket(
      name: name,
    ),
  );
}
