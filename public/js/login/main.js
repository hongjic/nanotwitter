require.config({
  baseUrl: "/",
  paths: {
    jquery: "js/jquery.min-2.1.4",
    Util: "js/util",
  },
  waitSeconds: 10
})

$("#search").click(function() {
  window.location = "/login.html";
});

$("#user-menu").click(function() {
  var menu = $("#user-menu");
  if (menu.hasClass("open"))
    menu.removeClass("open");
  else
    menu.addClass("open");
});


require(['Util'], function(Util) {

  $("#sign_in").click(function(){
    var username = $("#username").val();
    var password = $("#password").val();
    data = {username: username, password: password};
    $.ajax({
      type: "post",
      contentType: "application/json;charset=utf-8",
      dataType: "json",
      url: "/api/v1/users/login",
      data: JSON.stringify(data),
      success: function(result) {
        if (result.resultCode == "success") {
          token = result.resultMsg.access_token;
          Util.setCookie("access_token", token);
          window.location = "/";
        }
        else $("#tips").text(result.resultMsg);
      }
    })
  });

});