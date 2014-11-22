class WhitsonWedding.Views.UserActions extends Backbone.View
  el: '#user'
  template: JST['user']
  initialize: (options)->
    @$el = $(@el)
  accessToken: =>
    sessionStorage.getItem(WhitsonWedding.Config.currentUserStorageKey)
  signedIn: ->
    @accessToken() != null
  viewContext: ->
    {
      accessToken: @accessToken(),
      signedIn: @signedIn()
    }
  render: =>
    accessToken = @accessToken()
    @$el.html(@template(@viewContext()))
    $logout = @$el.find('a.logout')
    $logout.on 'click', ->
      $.ajax '/api/logout.json',
        type: 'DELETE'
        beforeSend: (request)->
          request.setRequestHeader('access_token', accessToken)
        contentType: 'application/json'
        dataType: 'json'
        success: (data)->
          sessionStorage.removeItem(WhitsonWedding.Config.currentUserStorageKey)
          $el.trigger('user:logout')

