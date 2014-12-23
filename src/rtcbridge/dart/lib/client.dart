library rtcbridge;

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
      // TODO(bluecmd): Use protobufs here
      print('Got SDP: ${s.sdp}, type: ${s.type}');
      this._signalingSocket.send(s.sdp);
    });

    this._serverPeer = pc;
    this._channelOpen = true;
    connectedCb();
  }

  void connect(String url, connectedCb()) {
    print('Connecting to signaling socket: $url');
    // TODO(bluecmd): Replace with Python Channels
    //this._signalingSocket = new WebSocket(url);
    //this._signalingSocket.onOpen.listen((Event e) {
    //  print('Signaling socket connected');
    //  this._signalingOpen = true;
    //  this._offer(connectedCb);
    //});

    //this._signalingSocket.onError.listen((Event e) {
    //  print('Signaling socket error');
    //});
  }

  void send(Uint8List data) {
    if (!this._channelOpen) {
      throw('Data channel not established');
    }
    print('Sending: $data');
    // TODO(bluecmd): Actually send data
  }

}
