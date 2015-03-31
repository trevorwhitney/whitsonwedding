WhitsonWedding.Models.User = Backbone.Model.extend
  urlRoot: WhitsonWedding.Config.apiBaseUrl + '/users'
  accessToken: ->
    @attributes.access_token
  isAdmin: ->
    @attributes.is_admin
