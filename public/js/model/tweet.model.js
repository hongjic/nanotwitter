define(['Backbone'], function (Backbone) {
  var Tweet = Backbone.Model.extend({

    url: '/api/v1/tweets',

    beforeParse: function(resp) {
      if (resp.resultCode == "error") 
        return null;
      return resp.resultMsg.tweet;
    },

    parse: function(tweet, options) {
      tweet.create_time = tweet.create_time * 1000;
      return tweet;
    }

  });

  return Tweet;
})