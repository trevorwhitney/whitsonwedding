class AccessTokenStrategy < Warden::Strategies::Base
  def valid?
    # Validate that the access token is properly formatted.
    # Currently only checks that it's actually a string.
    access_token.is_a?(String)
  end

  def authenticate!
    # Authorize request if HTTP_ACCESS_TOKEN matches 'youhavenoprivacyandnosecrets'
    # Your actual access token should be generated using one of the several great libraries
    # for this purpose and stored in a database, this is just to show how Warden should be
    # set up.
    session = Session.where(access_token: access_token).first
    access_granted = (session.present?)
    !access_granted ? fail!("Could not log in") : success!(User.find(session.user_id))
  end

  private

  def access_token
    request.env['HTTP_ACCESS_TOKEN'] || request.params['access_token']
  end
end
Warden::Strategies.add(:access_token, AccessTokenStrategy)

class PasswordStrategy < Warden::Strategies::Base
  def valid?
    params['email'] || params['password']
  end

  def authenticate!
    user = User.authenticate(params['email'], params['password'])
    user.present? ? success!(user) : fail!('Could not log in')
  end
end
Warden::Strategies.add(:password, PasswordStrategy)
