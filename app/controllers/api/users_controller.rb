module Api
  class UsersController < Api::ApplicationController
    skip_before_filter :authenticate!

    def create
      guest = Guest.find_by_email(params[:email])
      user = User.new(user_params(guest))
      if guest.present?
        user.save
        status = 200
      else
        user.errors[:email] << 'does not match any emails we have on our guest list. ' +
                        "Maybe we have a different email for you? If you've tried them all, please let Trevor " +
                        'know at trevorjwhitney@gmail.com.'
        status = 400
      end

      render json: present_user(user), status: status
    end

    def user_params(guest)
      params.permit(:email, :password).merge(
        guest: guest
      )
    end

    private

    def present_user(user)
      user.attributes.merge(
        errors: user.errors
      )
    end
  end
end
