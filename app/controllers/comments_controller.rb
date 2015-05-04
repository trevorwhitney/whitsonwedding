class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save!
      render json: comment, status: 201
    else
      render json: comment, status: 400
    end
  end

  private

  def comment_params
    params.permit(:body)
  end
end
