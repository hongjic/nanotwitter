define(['Backbone', 'underscore', 'Tweet'], function (Backbone, _, Tweet) {
  var Tweets = Backbone.Collection.extend({
    url: '/api/v1/homeline',
    model: Tweet,

    parse: function(resp) {
      return resp.resultMsg.home_line;
    }

  })
  return Tweets;
})