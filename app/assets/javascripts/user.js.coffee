$(()->
  userActions = new WhitsonWedding.Views.UserActions()
  userActions.render()

  signInModal = new WhitsonWedding.Views.SignInView()
  signInModal.render()

  rsvpModal = new WhitsonWedding.Views.RsvpView()
  rsvpModal.render()

  guestList = new WhitsonWedding.Views.GuestList()

  $('#login').on('user:login', userActions.render)
  $('#user').on('user:logout', userActions.render)
  $('#rsvp').on('show.bs.modal', ->
    console.log('RSVP clicked, showing modal and rendering')
    guestList.render()
  ) 
)
