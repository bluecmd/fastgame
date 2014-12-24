var appengine = require('appengine');
var parser = require('body-parser');
var express = require('express');
var webrtc = require('wrtc');

var app = express();

app.use(appengine.middleware.base);
app.use(parser.json());

app.get('/_ah/health', function(req, res) {
  res.set('Content-Type', 'text/plain');
  res.send(200, 'ok');
});

app.get('/_ah/start', function(req, res) {
  res.set('Content-Type', 'text/plain');
  res.send(200, 'ok');
});

app.get('/_ah/stop', function(req, res) {
  res.set('Content-Type', 'text/plain');
  res.send(200, 'ok');
  process.exit();
});

app.post('/connect', function(req, res) {
  appengine.logOneLine(req, 'New connection', appengine.LogLevel.INFO);

  var mediaConstraints = {
    'optional': [{
      'RtpDataChannels': true,
      'DtlsSrtpKeyAgreement': false
    }]
  };

  var pc = new webrtc.RTCPeerConnection(
    {iceServers: [{url:'stun:stun.l.google.com:19302'}]},
    mediaConstraints);

  pc.onicecandidate = function(candidate) {
    var msg = JSON.stringify(candidate);
    appengine.logOneLine(req, 'New candidate: ' + msg, appengine.LogLevel.INFO);
  }

  var offer = new webrtc.RTCSessionDescription(
    {'sdp': req.body.sdp, 'type': req.body.type});

  pc.setRemoteDescription(
      offer, function() {
    pc.createAnswer(function(answer) {
      pc.setLocalDescription(answer, function() {
        res.json({'sdp': answer.sdp, 'type': answer.type});
      });
    });
  });
  res.json({});
});

app.listen(8080, '0.0.0.0');
console.log('Listening on port 8080');
