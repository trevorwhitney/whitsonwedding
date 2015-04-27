WhitsonWedding.Models.User = Backbone.Model.extend
  urlRoot: WhitsonWedding.Config.apiBaseUrl + '/users'
  accessToken: ->
    @attributes.access_token
  isAdmin: ->
    @attributes.is_admin
  initialize: ->
    @guests = new WhitsonWedding.Collections.GuestList()
    @guests.url = @urlRoot + '/' + @id + '/guests'
    @guests.bind('reset', @updateCounts)
