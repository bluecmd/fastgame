library fastgame;

import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';
import 'package:rtcbridge/client.dart';

void main() {
  print('Starting fastgame client');
  BridgeClient client = new BridgeClient();
  client.connect('ws://${window.location.host}/bridge',
      () => client.send(UTF8.encode('hello')));
}
