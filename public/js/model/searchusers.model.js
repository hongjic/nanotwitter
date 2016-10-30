define(['Backbone', 'User'], function (Backbone, User) {
  
  var SearchUsers = Backbone.Collection.extend({
    url: '/api/v1/search/users',

    model: User,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return null;
      return resp.resultMsg.users;
    },

    parse: function(users, options) {
      return users;
    }
  })

  return SearchUsers;

});