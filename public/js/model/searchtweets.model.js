define(['Backbone', 'Tweet'], function (Backbone, Tweet) {

  var SearchTweets = Backbone.Collection.extend({
    url: 'api/v1/search/tweets',

    model: Tweet,

    beforeParse: function(resp) {
      if (resp.resultcode == "error")
        return false;
      return resp.resultMsg.tweets;
    },

    parse: function(tweets, options) {
      return tweets;
    }

  });

  return SearchTweets;

});