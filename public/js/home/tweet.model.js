define(['Backbone', 'underscore'], function (Backbone, _) {
  var Tweet = Backbone.Model.extend({

    url: '/api/v1/tweets',

    beforeParse: function(resp) {
      if (resp.resultCode == "error") 
        return false;
      return resp.resultMsg.tweet;
    },

    parse: function(tweet, options) {
      tweet.create_time = tweet.create_time * 1000;
      return tweet;
    }

  });

  return Tweet;
})