class WhitsonWedding.Models.Guest extends Backbone.Model
  urlRoot: '/guests'
  fullName: ->
    name = [
      @get('first_name'),
      @get('last_name'),
    ].join(' ')
  rsvp: ->
    @get('rsvp')
  attending: ->
    @get('attending')
  attendingRehearsal: ->
    @get('attending_rehearsal')
