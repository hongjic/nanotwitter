define(['Backbone', 'Tweet'], function (Backbone, Tweet) {

  var Likes = Backbone.Collection.extend({
    initialize: function(user_id) {
      this.user_id = user_id;
    },

    url: function() {
      return '/api/v1/users/' + this.user_id.toString() + '/likes'
    },

    model: Tweet,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return null;
      return resp.resultMsg.tweets;
    },

    parse: function(tweets, options) {
      return tweets;
    }

  });

  return Likes;

});