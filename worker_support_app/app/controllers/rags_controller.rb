class RagsController < ApplicationController

  def create
    rag_service = RagService.new(params[:query])
    answer = rag_service.generate_answer_with_retrieval

    render json: { answer: answer }
  end
end
