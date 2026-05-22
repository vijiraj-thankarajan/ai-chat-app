class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        message = chat.messages.last
        message.broadcast_append_chunk(chunk.content)
      end
    end
  rescue RubyLLM::RateLimitError
    chat.messages.create!(
      role: "assistant",
      content: "I am currently rate-limited by the AI provider. Please wait a moment and try again."
    )
  rescue StandardError
    chat.messages.create!(
      role: "assistant",
      content: "Sorry, I could not generate a response right now. Please try again."
    )
  end
end
