WhitsonWedding.currentUser = ->
  currentUser = $.cookie(WhitsonWedding.Config.currentUserStorageKey) || null
  return null unless currentUser?
  new WhitsonWedding.Models.User(currentUser)

WhitsonWedding.setCurrentUser = (accessToken, userId, firstName, lastName)->
  user = new WhitsonWedding.Models.User(id: userId, access_token: accessToken, first_name: firstName, last_name: lastName)
  user.fetch

  $.cookie(WhitsonWedding.Config.currentUserStorageKey, user, {expires: 7})

WhitsonWedding.clearCurrentUser = ->
  $.removeCookie(WhitsonWedding.Config.currentUserStorageKey)
  
