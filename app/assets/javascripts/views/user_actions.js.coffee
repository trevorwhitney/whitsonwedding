WhitsonWedding.Views.UserView = Backbone.View.extend
  el: '#user'
  template: JST['user']
  initialize: (options)->
    @$el = $(@el)
  accessToken: =>
    sessionStorage.getItem('whitsonwedding_access_token')
  signedIn: ->
    @accessToken() != null
  viewContext: ->
    {
      accessToken: @accessToken(),
      signedIn: @signedIn()
    }
  render: ->
    @$el.html(@template(@viewContext()))
    @$el.find('a.logout').on 'click', ->
      $.ajax '/api/logout.json',
        type: 'DELETE'
        beforeSend: (request)->
          request.setRequestHeader('access_token', _accessToken())
        contentType: 'application/json'
        dataType: 'json'
        success: (data)->
          sessionStorage.removeItem('whitsonwedding_access_token')
          $el.trigger('user:logout')

