define(['Backbone', 'Tweet'], function (Backbone, Tweet) {
  var HomeLine = Backbone.Collection.extend({
    url: '/api/v1/homeline',
    model: Tweet,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return false;
      return resp.resultMsg.home_line;
    },

    parse: function(home_line, options) {
      return home_line;
    }
  })

  return HomeLine;

})