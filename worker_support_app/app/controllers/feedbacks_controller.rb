class FeedbacksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    feedback_service = FeedbackService.new(params[:query])
    feedback = feedback_service.generate_feedback

    render json: { feedback: feedback }
  end
end
