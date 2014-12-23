import webapp2


class IndexPage(webapp2.RequestHandler):

    def get(self):
        self.response.redirect('/fastgame.html')


index = webapp2.WSGIApplication([('/', IndexPage),])
