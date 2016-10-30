define(['Backbone', 'User'], function (Backbone, User) {
  
  var Followers = Backbone.Collection.extend({
    
    initialize: function(user_id) {
      this.user_id = user_id;
    },
    
    url: function() {
      return '/api/v1/users/' + this.user_id.toString() + '/followers'
    },

    model: User,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return null;
      return resp.resultMsg.followers;
    },

    parse: function(followers, options) {
      return followers;
    }
  })

  return Followers;

});