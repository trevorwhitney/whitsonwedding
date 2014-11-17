WhitsonWedding.currentUser = ->
  currentUserJson = sessionStorage.getItem(WhitsonWedding.currentUserStorageKey)
  return null if currentUserJson == null

  currentUserAttributes = JSON.parse(currentUserJson)

  new WhitsonWedding.Models.User(currentUserAttributes)  

WhitsonWedding.setCurrentUser = (accessToken, userId)->
  user = new WhitsonWedding.Models.User(id: userId, access_token: accessToken)
  user.fetch

  sessionStorage.setItem(WhitsonWedding.currentUserStorageKey, user.toJSON())
