class GuestsController < ApplicationController
  def update
    @guest = Guest.find(params[:id])

    if current_user.can_rsvp_for?(@guest) && @guest.update!(rsvp: params[:rsvp])
      render json: @guest, status: 200
    else
      render json: @guest, status: 400
    end
  end

  def index
    user = User.find(params[:user_id])
    invitation = user.invitation
    guests = invitation.guests

    render json: guests
  end
end
