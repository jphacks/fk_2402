class StaticPagesController < ApplicationController
  def home
  end

  def rag
    @question = current_user.questions.build if logged_in?
  end

  def about
  end

  def feedback
  end
end
