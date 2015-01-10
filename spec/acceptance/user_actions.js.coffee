casper.test.begin 'A user can log in and logout', 5, (test)->
  casper.start 'http://localhost:3030', ->

  casper.then ->
    test.assertExists('a.login', 'page has a Log In link when not logged in')

    @click 'a.login'
    @fill 'form#sign-in-form', {
      email: 'tester@example.com',
      password: 'secret'
    }, true
    
    @waitForSelector('a.logout', ->
      test.assertExists('a.logout', 'page has a Log Out link when logged in')

      test.assertEval(->
        sessionStorage.getItem('whitsonwedding.com:current_user') != null
      , 'Access token set in session storage after login'
      )

      @click 'a.logout'

      @waitForSelector('a.login', ->
        test.assertExists('a.login', 'page has a Login link after logout')

        test.assertEval(->
          sessionStorage.getItem('whitsonwedding.com:current_user') == null
        , 'Access token cleared from session storage after logout' 
        )
      , ->
        @die('Login link did not appear after logout', 1)
      )

    , ->
      @die('Logout link did not appear after login', 1)
    )

  casper.run ->
    test.done()
