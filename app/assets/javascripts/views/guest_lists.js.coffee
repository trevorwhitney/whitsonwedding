class WhitsonWedding.Views.GuestList extends Backbone.View
  el: '#guest-list'
  template: JST['guestList']
  events:
    "click .rsvp-yes": "rsvpYes",
    "click .rsvp-no": "rsvpNo",
    'click #close-notifications': "closeNotifications"
  initialize: (options)->
    @$el = $(@el)
    @guests = {}
  closeNotifiactions: ->
    $('#rsvp-notifications').addClass('hidden') 
  rsvpYes: (e)=>
    guestId = $(e.currentTarget).data('id')
    guest = @guests.get(guestId)
    deferred = guest.save({rsvp: true})
    deferred.done (data, status, jqXHR) ->
      notifications = $('#rsvp-notifications')
      notifications.removeClass('hidden')
      successBox = '<div class="alert alert-success" role="alert">' +
          "RSVP successfully received for " +
          "<strong>#{guest.fullName()}</strong>. " + 
          "So glad you can make it, we look forward to seeing you!" +
          '</div>'
      notifications.find('.content').html(
        successBox
      )
  rsvpNo: (e)->
    guestId = $(e.currentTarget).data('id')
    guest = @guests.get(guestId)
    deferred = guest.save({rsvp: false})
    deferred.done (data, status, jqXHR) ->
      notifications = $('#rsvp-notifications')
      notifications.removeClass('hidden')
      successBox = '<div class="alert alert-success" role="alert">' +
            "RSVP successfully received for " +
            "<strong>#{guest.fullName()}</strong>. We're sorry you " +
            "can't make it, hopefully we can celebrate with you " +
            "sometime soon!" +
          "</div>"
      notifications.find('.content').html(
        successBox
      )
  render: =>
    if WhitsonWedding.currentUser()
      guests = WhitsonWedding.currentUser().guests
      deferred = guests.fetch({reset: true})
      deferred.done (data, status, jqXHR) =>
        console.log('fetched guests ' + guests)
        @guests = guests
        viewContext = {guests: guests.models}
        @$el.html(@template(viewContext))
        @delegateEvents()
    else
      @$el.html(@template())
      @delegateEvents()
    return @
