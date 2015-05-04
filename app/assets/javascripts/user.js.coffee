$(()->
  userActions = new WhitsonWedding.Views.UserActions()
  userActions.render()

  signInModal = new WhitsonWedding.Views.SignInView()
  signInModal.render()

  $('#login').on('user:login', userActions.render)
  $('#user').on('user:logout', userActions.render)
)
