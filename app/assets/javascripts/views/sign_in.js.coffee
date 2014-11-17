WhitsonWedding.Views.SignInView = Backbone.View.extend
  el: '#login'
  template: JST['signInModal']
  initialize: (options)->
    @$el = $(@el)
  render: ->
    @$el.html(@template())
    @$el.find('#sign-in-form').on 'submit', (event)->
      event.preventDefault()
      formCredentials = $(event.currentTarget).serializeArray()
      credentials = {}
      for cred in formCredentails 
        do (cred)->
          credentials[cred['name']] = cred['value']

      $.ajax '/api/login.json',
        type: 'POST'
        data: JSON.stringify({email: credentials['email'], password: credentials['password']})
        contentType: 'application/json'
        dataType: 'json'
        success: (data)->
          sessionStorage.setItem('whitsonwedding_access_token', data['access_token'])
          console.log($el)
          $el.trigger('user:login')

