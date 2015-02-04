class WhitsonWedding.Views.SignInView extends Backbone.View
  el: '#login'
  template: JST['signInModal']
  initialize: (options)->
    @$el = $(@el)
  presentErrors: (errorsHash) =>
    @$el.find('.errors').removeClass('hidden')
    for error, messages of errorsHash
      do (error) =>
        @$el.find(".form-group.#{error}").addClass('has-error')
        @$el.find(".#{error}-errors").append("<strong>#{error}</strong> #{messages.join()}")
  render: =>
    @$el.html(@template())
    @$el.find('#show-create-account').on 'click', (event)=>
      event.preventDefault()
      @$el.find('.login-element').toggleClass('hidden')
      @$el.find('.create-account-element').toggleClass('hidden')
    
    @$el.find('#show-sign-in').on 'click', (event)=>
      event.preventDefault()
      @$el.find('.create-account-element').toggleClass('hidden')
      @$el.find('.login-element').toggleClass('hidden')

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

    @$el.find('#create-account-form').on 'submit', (event)=>
      event.preventDefault()
      formCredentials = $(event.currentTarget).serializeArray()
      credentials = {}
      for cred in formCredentials 
        do (cred)->
          credentials[cred['name']] = cred['value']

      $.ajax '/api/sign_up.json',
        type: 'POST'
        data: JSON.stringify({email: credentials['email'], password: credentials['password']})
        contentType: 'application/json'
        dataType: 'json'
        error: (xhr, error) =>
          @presentErrors(xhr.responseJSON.errors)
        success: (data)=>
          sessionStorage.setItem(WhitsonWedding.Config.currentUserStorageKey, data['access_token'])
          $('#loginModal').modal('hide')
          @$el.trigger('user:login')

