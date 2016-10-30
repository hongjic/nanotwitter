define(['Backbone', 'User'], function (Backbone, User) {
  
  var Followings = Backbone.Collection.extend({
    
    initialize: function(user_id) {
      this.user_id = user_id;
    },

    url: function() {
      return '/api/v1/users/' + this.user_id.toString() + '/followings'
    },

    model: User,

    beforeParse: function(resp) {
      if (resp.resultCode == "error")
        return null;
      return resp.resultMsg.followings;
    },

    parse: function(followings, options) {
      return followings;
    }
  })

  return Followings;

});