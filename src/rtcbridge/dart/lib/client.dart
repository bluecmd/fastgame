library rtcbridge;

import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

class BridgeClient {

  var _iceServers;
  var _serverPeer;

  var _channelOpen = false;
  var _channel;
  var _signalingOpen = false;
  var _signalingSocket;

  BridgeClient() {
    print('Constructed bridge client');
    this._iceServers = ['stun:stun.l.google.com:19302'];
  }

  void _offer(connectedCb()) {
    var rtcIceServers = {
      'iceServers': []
    };
    var mediaConstraints = {
      'optional': [{
        'RtpDataChannels': true
      }]
    };
    for (var url in this._iceServers) {
      rtcIceServers['iceServers'].add({
        'url': url
      });
    }
    var pc = new RtcPeerConnection(rtcIceServers, mediaConstraints);
    pc.onIceCandidate.listen((e) {
      var candidate = e.candidate.candidate;
      print('Candidate: $candidate');
    });
    pc.onDataChannel.listen((e) {
      print('New data channel: $e');
    });

    var channel = pc.createDataChannel('bridge', { 'reliable': false });
    this._channel = channel;

    pc.createOffer().then((s) {
      pc.setLocalDescription(s);

      print('Got SDP: ${s.sdp}, type: ${s.type}');

      var request = new HttpRequest();
      request.onReadyStateChange.listen((_) {
        if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
        print('Got remote: ${request.responseText}');
        Map map = JSON.decode(request.responseText);
        this._serverPeer.setRemoteDescription(map);
        this._channelOpen = true;
        connectedCb();
        }
      });

      request.open('POST', '/connect', async: false);
      var map = new Map();
      map['sdp'] = s.sdp;
      map['type'] = s.type;
      request.send(JSON.encode(map));
    });

    this._serverPeer = pc;
  }

  void connect(String token, connectedCb()) {
    print('Connecting to signaling channel: $token');
    this._offer(connectedCb);
  }

  void send(Uint8List data) {
    if (!this._channelOpen) {
      throw('Data channel not established');
    }
    print('Sending: $data');
    // TODO(bluecmd): Actually send data
  }

}
