library rtcbridge;

import 'dart:async';
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
  var _localDescription;
  var _candidates = [];

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
      this._candidates.add(candidate);
    });

    pc.onIceConnectionStateChange.listen((e) {
      print('State: ${pc.iceGatheringState}');
    });

    pc.onDataChannel.listen((e) {
      print('New data channel: $e');
    });

    var channel = pc.createDataChannel('bridge', { 'reliable': false });
    this._channel = channel;
    this._serverPeer = pc;

    new Timer.periodic(new Duration(milliseconds: 100), (Timer timer) {
      if (pc.iceGatheringState != 'complete' ||
          pc.signalingState != 'have-local-offer')
        return;
      timer.cancel();

      var request = new HttpRequest();

      request.onReadyStateChange.listen((_) {
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
        print('Got remote: ${request.responseText}');
        Map map = JSON.decode(request.responseText);
        var candidates = map['candidates'];
        map.remove('candidates');

        print(map);
        print(candidates);
        this._serverPeer.setRemoteDescription(new RtcSessionDescription((map)));
        this._channelOpen = true;
        connectedCb();
        }
      });

      request.open('POST', '/connect', async: false);
      var map = new Map();
      map['sdp'] = this._localDescription.sdp;
      map['type'] = this._localDescription.type;
      map['candidates'] = this._candidates;
      request.send(JSON.encode(map));
    });

    pc.createOffer().then((s) {
      pc.setLocalDescription(s);
      print('Got SDP: ${s.sdp}, type: ${s.type}');
      this._localDescription = s;
    });
  }

  void connect(connectedCb()) {
    print('Connecting to signaling ..');
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
