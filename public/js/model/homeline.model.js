define(['Backbone', 'Tweet', 'Util'], function (Backbone, Tweet, Util) {
  var HomeLine = Backbone.Collection.extend({
    url: '/api/v1/homeline',
    model: Tweet,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return null;
      return resp.resultMsg.home_line;
    },

    parse: function(home_line, options) {
      return this.toJSON().concat(home_line);
    }
  })

  return HomeLine;

})