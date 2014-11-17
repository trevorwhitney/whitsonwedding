describe 'User', ->
  joe = null
  responseParams = {email: 'joe@example.com', id: 42}

  beforeEach ->
    jasmine.Ajax.install()
    joe = new WhitsonWedding.Models.User(id: 42)
    
  afterEach ->
    jasmine.Ajax.uninstall()

  describe '#fetch', ->
    request = null
    fetchAndRespond = ->
      joe.fetch()
      request = respondToMostRecentAjaxRequestWith(responseParams)

    describe 'when successful', ->
      it 'correctly hydrates the model based on the response', ->
        fetchAndRespond()
        expect(joe.get('email')).toEqual('joe@example.com')
        expect(joe.get('id')).toEqual(42)

