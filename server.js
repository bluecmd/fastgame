var appengine = require('appengine');
var express = require('express');

var app = express();

app.use(appengine.middleware.base);

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

app.get('/hello', function(req, res) {
  var env = req.appengine.devappserver ? 'the dev appserver' : 'production';
  res.send('Hello, world from ' + env + '!');
});

app.listen(8080, '0.0.0.0');
console.log('Listening on port 8080');
