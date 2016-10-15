define(['Backbone', 'underscore'], function (Backbone, _) {
  var Tweet = Backbone.Model.extend({

    url: '/tweets',

    parse: function(resp, options) {
      t = new Date(resp.create_time * 1000);
      resp.create_time = t.toLocaleString();
      return resp;
    }

  });

  return Tweet;
})