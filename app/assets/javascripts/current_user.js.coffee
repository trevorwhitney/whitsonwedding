WhitsonWedding.currentUser = ->
  currentUserJson = sessionStorage.getItem(WhitsonWedding.Config.currentUserStorageKey)
  return null if currentUserJson == null

  currentUserAttributes = JSON.parse(currentUserJson)

  new WhitsonWedding.Models.User(currentUserAttributes)  

WhitsonWedding.setCurrentUser = (accessToken, userId, firstName, lastName)->
  user = new WhitsonWedding.Models.User(id: userId, access_token: accessToken, first_name: firstName, last_name: lastName)
  user.fetch

  sessionStorage.setItem(WhitsonWedding.Config.currentUserStorageKey, JSON.stringify(user))
