define(['Backbone', 'Tweet'], function (Backbone, Tweet) {

  var TimeLine = Backbone.Collection.extend({
    initialize: function(user_id) {
      this.user_id = user_id;
    },

    url: function() {
      return '/api/v1/users/' + this.user_id.toString() + '/tweets'
    },

    model: Tweet,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return false;
      return resp.resultMsg.time_line;
    },

    parse: function(time_line, options) {
      return time_line;
    }

  });

  return TimeLine;

});