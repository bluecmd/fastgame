library fastgame;

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:rtcbridge/client.dart';


void main() {
  print('Starting fastgame client');

  BridgeClient client = new BridgeClient();
  client.connect(
      () => client.send(UTF8.encode('hello')));
}
