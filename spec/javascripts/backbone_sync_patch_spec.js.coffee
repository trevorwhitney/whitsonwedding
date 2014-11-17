describe 'Backbone.sync', ->
  joe = null
  params = {email: 'joe@example.com', id: 42}

  beforeEach ->
    jasmine.Ajax.install()

    joe = new WhitsonWedding.Models.User(
      id: 42, 
      access_token: 'abc123', 
      url: 'http://localhost:3000/api/login.json'
    )
    
  afterEach ->
    jasmine.Ajax.uninstall()

  describe 'when current user is set', ->
    beforeEach ->
      spyOn(WhitsonWedding, 'currentUser').and.returnValue(joe)

    it 'includes the current users access_token as a header when doing a get request', ->
      joe.fetch()
      request = respondToMostRecentAjaxRequestWith(params)
      expect(request.method).toEqual('GET')
      expect(request.url).toEqual("#{WhitsonWedding.Config.apiBaseUrl}/users/42")
      expect(request.requestHeaders['access_token']).toEqual('abc123')

    it 'includes the current users access_token in header when doing a create', ->
      susan = new WhitsonWedding.Models.User(email: 'susan@example.com')
      susan.save()

      request = respondToMostRecentAjaxRequestWith({id: 13, email: 'susan@example.com'})
      expect(request.url).toEqual("#{WhitsonWedding.Config.apiBaseUrl}/users")
      expect(request.method).toEqual('POST')
      expect(request.requestHeaders['access_token']).toEqual('abc123')
      expect(request.data()).toEqual({
        email: 'susan@example.com',
      })

    it 'includes the current users access_token in the header when doing an update', ->
      susan = new WhitsonWedding.Models.User(id: 13)
      susan.fetch()

      request = respondToMostRecentAjaxRequestWith({id: 13, email: 'susan@example.com'})

      susan.set('email', 'sue@example.com')
      susan.save()

      request = respondToMostRecentAjaxRequestWith(params)
      
      expect(request.method).toEqual('PUT')
      expect(request.url).toEqual("#{WhitsonWedding.Config.apiBaseUrl}/users/13")
      expect(request.requestHeaders['access_token']).toEqual('abc123')
      expect(request.data()).toEqual({
        id: 13,
        email: 'sue@example.com',
      })

    it 'includes the current users access_token in the header for deletes', ->
      bob = new WhitsonWedding.Models.User(id: 15)
      bob.fetch()

      request = respondToMostRecentAjaxRequestWith({id: 15, email: 'bob@example.com'})

      bob.destroy()
      request = respondToMostRecentAjaxRequestWithCustom(204, {})

      expect(request.url).toEqual("#{WhitsonWedding.Config.apiBaseUrl}/users/15")
      expect(request.method).toEqual('DELETE')
      expect(request.requestHeaders['access_token']).toEqual('abc123')


  describe 'when current user is not set', ->
    beforeEach ->
      spyOn(WhitsonWedding, 'currentUser').and.returnValue(null)

    it 'does not include an access token in the header on get requests', ->
      susan = new WhitsonWedding.Models.User(id: 13)
      susan.fetch()
      request = respondToMostRecentAjaxRequestWith({id: 13, email: 'susan@example.com'})
      expect(request.requestHeaders['access_token']).toBeUndefined()

    it 'does not include an access token in the header on post requests', ->
      susan = new WhitsonWedding.Models.User(email: 'susan@example.com')
      susan.save()

      request = respondToMostRecentAjaxRequestWith({id: 13, email: 'susan@example.com'})
      expect(request.requestHeaders['access_token']).toBeUndefined()

    it 'does not include an access token in the header on put requests', ->
      susan = new WhitsonWedding.Models.User(id: 13)
      susan.fetch()

      request = respondToMostRecentAjaxRequestWith({id: 13, email: 'susan@example.com'})

      susan.set('email', 'sue@example.com')
      susan.save()

      request = respondToMostRecentAjaxRequestWith(params)
      expect(request.requestHeaders['access_token']).toBeUndefined()

    it 'does not include an access token in the header on delete requests', ->
      bob = new WhitsonWedding.Models.User(id: 15)
      bob.fetch()

      request = respondToMostRecentAjaxRequestWith({id: 15, email: 'bob@example.com'})

      bob.destroy()
      request = respondToMostRecentAjaxRequestWithCustom(204, {})

      expect(request.requestHeaders['access_token']).toBeUndefined()
