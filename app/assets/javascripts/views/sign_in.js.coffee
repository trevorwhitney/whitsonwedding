class WhitsonWedding.Views.SignInView extends Backbone.View
  el: '#login'
  template: JST['signInModal']
  initialize: (options)->
    @$el = $(@el)
  render: =>
    @$el.html(@template())
    @$el.find('#sign-in-form').on 'submit', (event)=>
      event.preventDefault()
      formCredentials = $(event.currentTarget).serializeArray()
      credentials = {}
      for cred in formCredentials 
        do (cred)->
          credentials[cred['name']] = cred['value']

      $.ajax '/api/login.json',
        type: 'POST'
        data: JSON.stringify({email: credentials['email'], password: credentials['password']})
        contentType: 'application/json'
        dataType: 'json'
        success: (data)=>
          sessionStorage.setItem(WhitsonWedding.Config.currentUserStorageKey, data['access_token'])
          $('#loginModal').modal('hide')
          @$el.trigger('user:login')

