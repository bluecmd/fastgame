library fastgame;

import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';
import 'package:rtcbridge/client.dart';

void onNewChannel(String responseText) {
  var decoded = JSON.decode(responseText);

  BridgeClient client = new BridgeClient();
  client.connect(decoded['token'],
      () => client.send(UTF8.encode('hello')));
}

void main() {
  print('Starting fastgame client');
  HttpRequest.getString('/channel').then(onNewChannel);
}
