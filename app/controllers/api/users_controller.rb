module Api
  class UsersController < ApplicationController
    skip_before_filter :authenticate!

    def create
      guest = Guest.find_by_email(params[:email])
      user = User.new(user_params(guest))
      if guest.present?
        user.save

        access_token = SecureRandom.uuid
        Session.create!(user_id: user.id, access_token: access_token)

        status = 200
      else
        user.errors[:email] << 'does not match any emails we have on our guest list. ' +
                        "Maybe we have a different email for you? If you've tried them all, please let Trevor " +
                        'know at trevorjwhitney@gmail.com.'
        access_token = nil
        status = 400
      end

      render json: present_user(user, access_token), status: status
    end

    def user_params(guest)
      params.permit(:email, :password).merge(
        guest: guest
      )
    end

    private

    def present_user(user, access_token)
      presented_user = {
        id: user.id,
        email: user.email,
        errors: user.errors,
        access_token: access_token,
        is_admin: user.is_admin?
      }

      return presented_user unless user.guest_id

      presented_user.merge({
        first_name: user.try(:first_name),
        last_name: user.try(:last_name),
      })
    end
  end
end
