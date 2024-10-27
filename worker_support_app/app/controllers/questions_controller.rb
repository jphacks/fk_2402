class QuestionsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @question = current_user.questions.build(question_params)
        @question.image.attach(params[:question][:image])
        if request.path == '/feedback'
          create_feedback(@question)
        elsif
          if @question.save
            rag_service = RagService.new(params[:question][:content])
            @response_message = rag_service.generate_answer_with_retrieval
            flash[:success] = "Question created!#{params[:question][:content]}"
            @AI_question = current_user.questions.build(content: "#{@response_message}")
            @AI_question.save
            redirect_to communities_path
          else
            render 'static_pages/rag', status: :unprocessable_entity
          end
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
      params.require(:question).permit(:content, :image)
    end

    def correct_user
        @question = current_user.questions.find_by(id: params[:id])
        redirect_to root_url, status: :see_other if @question.nil?
    end


    def create_feedback(question)
      if question.save
        feedback_service = FeedbackService.new(params[:question][:content])
        @response_message = feedback_service.generate_feedback
        flash[:success] = "Question created!#{params[:question][:content]}"
        @AI_question = current_user.questions.build(content: "#{@response_message}")
        @AI_question.save
        redirect_to communities_path
      else
        render 'static_pages/feedback', status: :unprocessable_entity
      end
    end
end
