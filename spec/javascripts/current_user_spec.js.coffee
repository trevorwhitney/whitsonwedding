describe 'WhitsonWedding.currentUser', ->
  describe 'when no one is logged in', ->
    beforeEach ->
      sessionStorage.removeItem(WhitsonWedding.currentUserStorageKey)

    it 'returns null', ->
      currentUser = WhitsonWedding.currentUser()
      expect(currentUser).toBeNull()

  describe 'when a user is logged in', ->
    beforeEach ->
      sessionStorage.setItem(WhitsonWedding.currentUserStorageKey, '{"id":42,"email":"joe@example.com","access_token":"abc123"}')

    it 'returns the currently signed in user', ->
      currentUser = WhitsonWedding.currentUser()
      expect(currentUser.id).toEqual(42)
      expect(currentUser.get('email')).toEqual('joe@example.com')
      expect(currentUser.get('access_token')).toEqual('abc123')

describe 'WhitsonWedding.setCurrentUser', ->
  userDouble = null

  beforeEach ->
    sessionStorage.removeItem(WhitsonWedding.currentUserStorageKey)
    userDouble = new WhitsonWedding.Models.User
    spyOn(WhitsonWedding.Models, 'User').and.returnValue(userDouble)
    spyOn(userDouble, 'toJSON').and.returnValue('{"key":"value"}')

  it 'creates a user with the passed in access token and id', ->
    WhitsonWedding.setCurrentUser('abc123', 42)
    expect(WhitsonWedding.Models.User).toHaveBeenCalledWith({id: 42, access_token: 'abc123'}) 
  it 'stores the created user as json in the session storage', ->
    expect(sessionStorage.getItem(WhitsonWedding.currentUserStorageKey)).toBeNull()

    WhitsonWedding.setCurrentUser('abc123', 42)
    expect(sessionStorage.getItem(WhitsonWedding.currentUserStorageKey)).toEqual('{"key":"value"}')
