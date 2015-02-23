class WhitsonWedding.Views.UserActions extends Backbone.View
  el: '#user'
  template: JST['user']
  initialize: (options)->
    @$el = $(@el)
  signedIn: ->
    WhitsonWedding.currentUser() != null
  viewContext: ->
    {
      currentUser: WhitsonWedding.currentUser(),
      signedIn: @signedIn()
    }
  render: =>
    currentUser = WhitsonWedding.currentUser()
    @$el.html(@template(@viewContext()))
    $logout = @$el.find('a.logout')
    $logout.on 'click', =>
      $.ajax '/api/logout.json',
        type: 'DELETE'
        beforeSend: (request)->
          request.setRequestHeader('access_token', currentUser.accessToken())
        contentType: 'application/json'
        dataType: 'json'
        success: (data)=>
          debugger
          sessionStorage.removeItem(WhitsonWedding.Config.currentUserStorageKey)
          @$el.trigger('user:logout')

