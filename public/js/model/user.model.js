define(['Backbone'], function (Backbone) {
  var User = Backbone.Model.extend({

    url: '/api/v1/users',

    beforeParse: function(resp) {
      if (resp.resultCode == "error") 
        return null;
      return resp.resultMsg.user;
    },

    parse: function(user, options) {
      user.create_time = user.create_time * 1000;
      return user;
    }

  });

  return User;
})