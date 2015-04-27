class WhitsonWedding.Views.RsvpView extends Backbone.View
  el: '#rsvp'
  template: JST['rsvpModal']
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
    return @

