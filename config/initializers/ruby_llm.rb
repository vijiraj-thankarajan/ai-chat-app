RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", Rails.application.credentials.dig(:openai_api_key))
  config.openrouter_api_key = ENV.fetch("OPENROUTER_API_KEY", Rails.application.credentials.dig(:openrouter_api_key))
  config.default_model = "openai/gpt-oss-120b:free"

  # Use the new association-based acts_as API (recommended)
  config.use_new_acts_as = true
end
