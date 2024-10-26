class QuestionsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @question = current_user.questions.build(question_params)
        if @question.save
          flash[:success] = "Question created!"
          redirect_to rag_path
        else
          render 'static_pages/home', status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
        flash[:success] = "Question deleted"
        if request.referrer.nil?
          redirect_to root_url, status: :see_other
        else
          redirect_to request.referrer, status: :see_other
        end
      end

    private

    def question_params
      params.require(:question).permit(:content)
    end

    def correct_user
        @question = current_user.questions.find_by(id: params[:id])
        redirect_to root_url, status: :see_other if @question.nil?
    end

end
