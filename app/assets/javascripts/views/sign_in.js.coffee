class WhitsonWedding.Views.SignInView extends Backbone.View
  el: '#login'
  template: JST['signInModal']
  events:
    'click #close-login-error': 'closeLoginError'
    'click #show-create-account': 'showAccountCreation'
    'click #show-sign-in': 'showLogin'
    'click .alert .close': 'closeAlert'
    'submit #sign-in-form': 'submitSignIn'
    'submit #create-account-form': 'submitAccountCreation'
  initialize: (options)->
    @$el = $(@el)
  showLoginError: ->
    $('#login-error').removeClass('hidden')
  closeLoginError: ->
    $('#login-error').addClass('hidden') 
  closeAlert: (e)->
    $(e.currentTarget).parent().addClass('hidden')
  presentErrors: (errorsHash) =>
    for error, messages of errorsHash
      do (error, messages) =>
        @$el.find("input[name=#{error}]").val('')
        @$el.find(".form-group.#{error}").addClass('has-error')
        $errors = @$el.find("##{error}-errors")
        $errors.html '<button type="button" class="close">' +
            '<span aria-hidden="true">&times;</span>' +
          '</button>' +
          "<strong>#{error}</strong> #{messages.join(', ')}"
        $errors.removeClass('hidden')
  removeErrors: ->
    @$el.find('.alert-danger').addClass('hidden')
    @$el.find(".form-group.has-error").removeClass('has-error')
  submitSignIn: (event)=>
      event.preventDefault()
      formCredentials = $(event.currentTarget).serializeArray()
      credentials = {}
      for cred in formCredentials 
        do (cred)->
          credentials[cred['name']] = cred['value']

      @$el.find('input[name=password]').val('')
      deferred = $.ajax '/login.json',
        type: 'POST'
        data: JSON.stringify({email: credentials['email'], password: credentials['password']})
        contentType: 'application/json'
        dataType: 'json'
      deferred.done (data)=>
          WhitsonWedding.setCurrentUser(data.access_token, data.id, data.first_name, data.last_name, data.is_admin)
          @$el.find('input[name=email]').val('')
          $('#loginModal').modal('hide')
          @$el.trigger('user:login')
      deferred.fail (jqXHR, status, errorThrown)=>
          @showLoginError()
  submitAccountCreation: (event)=>
      event.preventDefault()
      @removeErrors()
      formCredentials = $(event.currentTarget).serializeArray()
      credentials = {}
      for cred in formCredentials 
        do (cred)->
          credentials[cred['name']] = cred['value']

      $.ajax '/sign_up.json',
        type: 'POST'
        data: JSON.stringify
          email: credentials['email']
          password: credentials['password']
          password_confirmation: credentials['password_confirmation']
        contentType: 'application/json'
        dataType: 'json'
        error: (xhr, error) =>
          @presentErrors(xhr.responseJSON.errors)
        success: (data)=>
          WhitsonWedding.setCurrentUser(data.access_token, data.id, data.first_name, data.last_name)
          @$el.find('input[name=email]').val('')
          @$el.find('input[name=password]').val('')
          @$el.find('input[name=password_confirmation]').val('')
          $('#loginModal').modal('hide')
          @$el.trigger('user:login')
  showAccountCreation: (event)=>
      event.preventDefault()
      @$el.find('.login-element').toggleClass('hidden')
      @$el.find('.create-account-element').toggleClass('hidden')
  showLogin: (event)=>
      event.preventDefault()
      @$el.find('.create-account-element').toggleClass('hidden')
      @$el.find('.login-element').toggleClass('hidden')
  render: =>
    @$el.html(@template())
    $('#loginModal').on('hidden.bs.modal', @closeLoginError)

