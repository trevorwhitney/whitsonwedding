class WhitsonWedding.Views.RsvpView extends Backbone.View
  el: '#content'
  template: JST['rsvpView']
  initialize: (options)->
    @$el = $(@el)
  presentErrors: (errorsHash) =>
    @$el.find('.errors').removeClass('hidden')
    for error, messages of errorsHash
      do (error) =>
        @$el.find(".form-group.#{error}").addClass('has-error')
        @$el.find(".#{error}-errors").append("<strong>#{error}</strong> #{messages.join()}")
  render: ->
    @$el.html(@template)
    guestList = new WhitsonWedding.Views.GuestList()
    guestList.render()
    return @

