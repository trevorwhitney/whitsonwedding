class AccessTokenStrategy < Warden::Strategies::Base
  def valid?
    # Validate that the access token is properly formatted.
    # Currently only checks that it's actually a string.
    access_token.is_a?(String)
  end

  def authenticate!
    session = Session.where(access_token: access_token).first
    access_granted = session.present?
    !access_granted ? fail!("Could not log in") : success!(User.find(session.user_id))
  end

  private

  def access_token
    request.env['HTTP_ACCESS_TOKEN'] || request.params['access_token']
  end
end

class AccessTokenAdminStrategy < Warden::Strategies::Base
  def valid?
    # Validate that the access token is properly formatted.
    # Currently only checks that it's actually a string.
    access_token.is_a?(String)
  end

  def authenticate!
    session = Session.where(access_token: access_token).first
    access_granted = session.present?
    fail!("Could not log in") unless access_granted

    user = User.find(session.user_id)
    user.is_admin? ? success!(user) : fail!("Could not log in")
  end

  private

  def access_token
    request.env['HTTP_ACCESS_TOKEN'] || request.params['access_token']
  end
end

Warden::Strategies.add(:access_token, AccessTokenStrategy)
Warden::Strategies.add(:access_token_admin, AccessTokenAdminStrategy)
