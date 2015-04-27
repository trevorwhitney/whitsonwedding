WhitsonWedding.currentUser = ->
  currentUser = $.cookie(WhitsonWedding.Config.currentUserStorageKey) || null
  return null unless currentUser?
  user = new WhitsonWedding.Models.User(currentUser)
  $(document).ajaxSend (event, request) -> 
     token = user.get('access_token')
     if token
       request.setRequestHeader('access_token', token);
  return user

WhitsonWedding.setCurrentUser = (accessToken, userId, firstName, lastName, isAdmin)->
  user = new WhitsonWedding.Models.User(
    id: userId, 
    access_token: accessToken, 
    first_name: firstName, 
    last_name: lastName,
    is_admin: isAdmin
  )
  user.fetch

  $.cookie(WhitsonWedding.Config.currentUserStorageKey, user, {expires: 7})

WhitsonWedding.clearCurrentUser = ->
  $.removeCookie(WhitsonWedding.Config.currentUserStorageKey)
  $(document).ajaxSend (event, request) -> 
     request.setRequestHeader('access_token', null);
  
