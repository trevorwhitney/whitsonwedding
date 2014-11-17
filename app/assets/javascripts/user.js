$(function() {
  var userView = new UserView();
  userView.render();

  var signInModal = new SignInView();
  signInModal.render();

  $('#login').on('user:login', userView.render);
  $('#user').on('user:logout', userView.render);
});
