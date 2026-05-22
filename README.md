# AI Chat App

A Rails 8.1 chat application powered by [RubyLLM](https://github.com/crmne/ruby_llm). Start conversations, send follow-up messages, browse provider models, and receive streaming assistant replies over Hotwire (Turbo Streams + Action Cable).

## Requirements

- Ruby (see `.ruby-version`)
- PostgreSQL (`ai_chat_dev`, `ai_chat_test`)
- API keys: `OPENAI_API_KEY` and/or `OPENROUTER_API_KEY` (or Rails credentials)

## Setup

```bash
bin/setup
bin/rails db:prepare
bin/dev
```

Run background jobs in another terminal when not using Puma-embedded Solid Queue:

```bash
bin/jobs
```

## Usage

- **/** — list chats and start a new conversation
- **/chats/:id** — view a chat and send messages (responses stream in real time)
- **/models** — browse models; use **Refresh** to sync the registry from providers

Default model is configured in `config/initializers/ruby_llm.rb` (`openai/gpt-oss-120b:free`).

## Architecture

1. User submits a prompt via `ChatsController` or `MessagesController`
2. `ChatResponseJob` calls `chat.ask(content)` with streaming chunks
3. `Message#broadcast_append_chunk` pushes tokens to the browser via Action Cable

## Testing & CI

```bash
bin/ci
```

GitHub Actions runs Brakeman, bundler-audit, importmap audit, RuboCop, and Rails tests on pull requests and pushes to `main`.

## Deployment

Docker and Kamal are configured in `Dockerfile` and `config/deploy.yml`. Update registry hosts, server IPs, and secrets before deploying.

## Security

- `config/master.key` and `.env*` are gitignored
- Store API keys in environment variables or `rails credentials:edit`
