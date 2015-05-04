class WhitsonWedding.Views.GuestList extends Backbone.View
  el: '#content'
  template: JST['guestList']
  events:
    'click .rsvp-yes': 'rsvpYes',
    'click .rsvp-no': "rsvpNo",
    'click .rsvp-rehearsal-yes': 'rsvpRehearsalYes',
    'click .rsvp-rehearsal-no': 'rsvpRehearsalNo',
    'submit #comment-form': 'leaveComment'
    'click #close-notifications': 'closeNotifications'
  initialize: (options)->
    @$el = $(@el)
    @guests = {}
  closeNotifications: ->
    $('#rsvp-notifications').addClass('hidden') 
  successNotification: (message)->
    successBox = "<div class='alert alert-success' role='alert'>#{message}</div>"
    notifications = $('#rsvp-notifications')
    notifications.removeClass('hidden')
    notifications.find('.content').html(
      successBox
    )
  failureNotification: (message)->
    message = "Uh-oh, something went wrong and we weren't able to " +
      "save your request. Are you logged in? If so, the server might be down, or " +
      "Trevor just probably wrote a bad website, and would be super grateful if you dropped " +
      "him a line to tell him what went wrong. Sorry for the trouble."
    failureBox = "<div class='alert alert-danger' role='alert'>#{message}</div>"
    notifications = $('#rsvp-notifications')
    notifications.removeClass('hidden')
    notifications.find('.content').html(
      failureBox
    )
  successRsvpYesNotification: (guestName) ->
    message = "RSVP successfully received for " +
      "<strong>#{guestName}</strong> for the wedding and reception on July 25th. " + 
      "So glad you can make it, we look forward to seeing you!"
    @successNotification(message)
  successRsvpNoNotification: (guestName) ->
    message = "RSVP successfully received for " +
            "<strong>#{guestName}</strong> for the wedding and reception. We're sorry you " +
            "can't make it, hopefully we can celebrate with you " +
            "sometime soon!"
    @successNotification(message)
  successRsvpRehearsalYesNotification: (guestName) ->
    message = "RSVP successfully received for " +
      "<strong>#{guestName}</strong> for the rehearsal dinner on July 24th. " + 
      "So glad you can make it, we look forward to seeing you!"
    @successNotification(message)
  successRsvpRehearsalNoNotification: (guestName) ->
    message = "RSVP successfully received for " +
            "<strong>#{guestName}</strong>. We're sorry you " +
            "can't make it to the rehearsal dinner. Hopefully we'll be seeing you at the wedding, " +
            "but if not, we hope to celebrate with you sometime soon."
    @successNotification(message)
  successCommentNotification: (guestName) ->
    message = "Saved comment, thanks for the message!" 
    @successNotification(message)
  rsvpYes: (e)=>
    guestId = $(e.currentTarget).data('id')
    guest = @guests.get(guestId)
    deferred = guest.save({attending: true})
    deferred.done (data, status, jqXHR) =>
      @successRsvpYesNotification(guest.fullName())
    deferred.fail =>
      @failureNotification()
  rsvpNo: (e)->
    guestId = $(e.currentTarget).data('id')
    guest = @guests.get(guestId)
    deferred = guest.save({attending: false})
    deferred.done (data, status, jqXHR) =>
      @successRsvpNoNotification(guest.fullName())
    deferred.fail =>
      @failureNotification()
  rsvpRehearsalYes: (e)=>
    guestId = $(e.currentTarget).data('id')
    guest = @guests.get(guestId)
    deferred = guest.save({attending_rehearsal: true})
    deferred.done (data, status, jqXHR) =>
      @successRsvpRehearsalYesNotification(guest.fullName())
    deferred.fail =>
      @failureNotification()
  rsvpRehearsalNo: (e)->
    guestId = $(e.currentTarget).data('id')
    guest = @guests.get(guestId)
    deferred = guest.save({attending_rehearsal: false})
    deferred.done (data, status, jqXHR) =>
      @successRsvpRehearsalNoNotification(guest.fullName())
    deferred.fail =>
      @failureNotification()
  leaveComment: (e)->
    e.preventDefault()
    formCredentials = $(e.currentTarget).serializeArray()
    credentials = {}
    for cred in formCredentials 
      do (cred)->
        credentials[cred['name']] = cred['value']

    $.ajax '/comments',
      type: 'POST'
      data: JSON.stringify({body: credentials['comment']})
      contentType: 'application/json'
      dataType: 'json'
      success: (data)=>
        $('textarea[name=comment]').val('')
        @successCommentNotification()
  render: =>
    if WhitsonWedding.currentUser()
      guests = WhitsonWedding.currentUser().guests
      deferred = guests.fetch({reset: true})
      deferred.done (data, status, jqXHR) =>
        @guests = guests
        viewContext = {guests: guests.models}
        @$el.html(@template(viewContext))
        @delegateEvents()
    else
      @$el.html(@template())
      @delegateEvents()
    return @
