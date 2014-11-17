class AccessTokenStrategy < Warden::Strategies::Base
  def valid?
    # Validate that the access token is properly formatted.
    # Currently only checks that it's actually a string.
    request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
  end

  def authenticate!
    # Authorize request if HTTP_ACCESS_TOKEN matches 'youhavenoprivacyandnosecrets'
    # Your actual access token should be generated using one of the several great libraries
    # for this purpose and stored in a database, this is just to show how Warden should be
    # set up.
    session = Session.where(access_token: request.env["HTTP_ACCESS_TOKEN"]).first
    access_granted = (session.present?)
    !access_granted ? fail!("Could not log in") : success!(User.find(session.user_id))
  end
end

Warden::Strategies.add(:access_token, AccessTokenStrategy)
