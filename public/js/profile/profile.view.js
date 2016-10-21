define(['Backbone', 'underscore', 'Timeline', 'Util', 'TEXT!js/profile/profile.tpl.html'], 
  function(Backbone, _, Timeline, Util, ProfileTpl) {

  var ProfileView = Backbone.View.extend({
    el: '#profile_content',

    events: {
      'click .reply': 'reply',
      'click .likes': 'likes',
    },

    template: _.template(ProfileTpl),

    initialize: function(user_id) {
      this.timeline = new Timeline(user_id);
      this.listenTo(this.timeline, 'sync', this.render);

    },

    render: function() {
      this.$el.html(this.template({time_line: this.timeline.toJSON()}));
    },

    query: function() {
      this.timeline.fetch({
        success: function(collection, resp, options) {
          console.log("success");
        },
        error: function(collection, resp, options) {
          window.location = "/login.html";
        }
      })
    },

    reply: function() {
      // TODO:
    },

    likes: function() {
      // TODO:
    }

  });

  return ProfileView;

});