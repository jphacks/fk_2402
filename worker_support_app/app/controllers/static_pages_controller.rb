class StaticPagesController < ApplicationController
  def home
  end

  def rag
    @question = current_user.questions.build if logged_in?
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def about
  end

  def feedback
  end
end
