# app/services/rag_service.rb
require "langchain"

class RagService
  def initialize(query)
    @query = query
    #@llm = Langchain::LLM.new
    @llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_API_KEY'])  # 特定のLLMを指定
  end

  def generate_answer_with_retrieval
    search_results = search_documents(@query)
    #デバッグ
    Rails.logger.debug "Search Results: #{search_results.inspect}"


    context = search_results.join("\n")

    # prompt = "質問: #{@query}\n検索結果:\n#{search_results.join("\n")}\n\n回答:"
    # response = @llm.generate(prompt)
    # response

    # prompt = "質問: #{@query}\n検索結果:\n#{search_results.join("\n")}\n\n回答:"
    
    # # `generate` の代わりに `chat` メソッドを使用
    # response = @llm.chat(messages: [{ role: "user", content: prompt }])
    # response.raw_response['choices'][0]['message']['content'] # 応答の内容を抽出


    prompt = <<~PROMPT
      以下の文書に基づいて質問に答えてください。できるだけ文書内の情報を利用して回答を生成してください。
      
      質問: #{@query}
      文書内容:
      #{context}

      回答:
      PROMPT

    # プロンプト内容をコンソールに出力（デバッグ）
    Rails.logger.debug "Generated Prompt: #{prompt}"

    # `generate` の代わりに `chat` メソッドを使用
    response = @llm.chat(messages: [{ role: "user", content: prompt }])
    # `@raw_response` からメッセージ内容を抽出
    accurate_response = response.raw_response["choices"][0]["message"]["content"]
    accurate_response = "#{@query}>>" + accurate_response
  end

  private

#   def search_documents(query)
#     # Langchainの検索機能を使用して文書を検索
#     Document.where("content LIKE ?", "%#{query}%").pluck(:content)
#   end

  def search_documents(query)
    Document.pluck(:content)
  end
end
