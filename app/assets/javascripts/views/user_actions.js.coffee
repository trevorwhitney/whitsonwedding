class WhitsonWedding.Views.UserActions extends Backbone.View
  el: '#user'
  template: JST['user']
  initialize: (options)->
    @$el = $(@el)
  signedIn: ->
    WhitsonWedding.currentUser() != null
  userIsAdmin: () ->
    return false unless @signedIn()
    WhitsonWedding.currentUser().isAdmin()
  adminLink: () ->
    return '#' unless @signedIn
    "/admin?access_token=#{WhitsonWedding.currentUser().accessToken()}"
  viewContext: ->
    baseContext = {
      currentUser: WhitsonWedding.currentUser(),
      userIsAdmin: @userIsAdmin(),
      signedIn: @signedIn()
    }
    return baseContext unless @userIsAdmin()

    adminContext = {
      adminLink: @adminLink(),
    }
    _.extend(baseContext, adminContext)
  render: =>
    currentUser = WhitsonWedding.currentUser()
    @$el.html(@template(@viewContext()))
    $logout = @$el.find('a.logout')
    $logout.on 'click', =>
      $.ajax '/logout.json',
        type: 'DELETE'
        beforeSend: (request)->
          request.setRequestHeader('access_token', currentUser.accessToken())
        contentType: 'application/json'
        dataType: 'json'
        success: (data)=>
          WhitsonWedding.clearCurrentUser()
          # should force a page reload to handle routes/permissions
          @$el.trigger('user:logout')

