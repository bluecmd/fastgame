import json
import uuid
import webapp2

from google.appengine.api import channel


class IndexPage(webapp2.RequestHandler):

  def get(self):
    self.redirect('/fastgame.html', permanent=True)


class ChannelPage(webapp2.RequestHandler):

  def get(self):
    token = channel.create_channel(str(uuid.uuid1()))
    self.response.headers['Content-Type'] = 'application/json'
    self.response.write(json.dumps({'token': token}))


application = webapp2.WSGIApplication([
  ('/', IndexPage),
  ('/channel', ChannelPage),
  ], debug=True)
