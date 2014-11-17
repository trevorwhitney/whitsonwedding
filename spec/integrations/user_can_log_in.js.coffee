casper.test.begin 'A user can log in', 2, (test)->
  casper.start 'http://localhost:3030', ->

  casper.then ->
    test.assertExists('a.login', 'page has a Log In link when not logged in')

    @click 'a.login'
    @fill 'form#sign-in-form', {
      email: 'twhitney@example.com',
      password: 'stones'
    }, true
    
    test.assertExists('a.logout', 'page has a Log Out link when logged in')

  casper.run ->
    test.done()
