import json
import uuid
import webapp2

from google.appengine.api import urlfetch


#RTCBRIDGE_ENDPOINT = 'https://rtcbridge-dot-bluecmd0.appspot.com/connect'
RTCBRIDGE_ENDPOINT = 'http://bob.cmd.nu:8000/connect'


class IndexPage(webapp2.RequestHandler):

  def get(self):
    self.redirect('/fastgame.html', permanent=True)


class ConnectPage(webapp2.RequestHandler):
  """Connect a client with the RTC bridge backend."""

  def post(self):
    # Filter incoming offer
    offer = json.loads(self.request.body)
    payload = json.dumps({'sdp': offer['sdp'], 'type': offer['type']})
    result = urlfetch.fetch(
        url=RTCBRIDGE_ENDPOINT, payload=payload, method=urlfetch.POST,
        headers={'Content-Type': 'application/json'}, follow_redirects=False)

    self.response.headers['Content-Type'] = 'application/json'
    self.response.write(result.content)


application = webapp2.WSGIApplication([
  ('/', IndexPage),
  ('/connect', ConnectPage),
  ], debug=True)
