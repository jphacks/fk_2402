# app/services/feedback_service.rb
require "langchain"

class FeedbackService
  def initialize(query)
    @query = query
    # OpenAIを利用したLLMのインスタンス化
    @llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
  end

  def generate_feedback
    documents = Document.all.pluck(:content)
    context = documents.join("\n")

    prompt = <<~PROMPT
      社員の質問: #{@query}

      回答方針:
      - 以下の「参考文書」に基づき、質問に対して丁寧かつ詳細に説明を行ってください。
      - 参考文書の内容に基づき、誤解を招かないよう正確に回答すること。
      - 社員は初心者であると仮定し、専門用語には説明を加えつつわかりやすく回答すること。
      - 回答には「ステップバイステップ」の手順を含め、必要に応じて例を用いること。

      参考文書:
      #{context}

      フィードバック:
      PROMPT

    # # completeメソッドを使用してテキスト生成を行う
    # response = @llm.complete(prompt: prompt)
    # response

    # `generate` の代わりに `chat` メソッドを使用
    response = @llm.chat(messages: [{ role: "user", content: prompt }])
    # `@raw_response` からメッセージ内容を抽出
    accurate_response = response.raw_response["choices"][0]["message"]["content"]
    accurate_response = "#{@query}>>" + accurate_response
  end
end
