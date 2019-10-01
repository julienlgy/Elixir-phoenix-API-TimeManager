# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :timeManager,
  ecto_repos: [TimeManager.Repo]

# Configures the endpoint
config :timeManager, TimeManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OsDjTsPqmEhNmL7iqi7bkTytEubNe6Vhxpw4tyUrA5EgxBZ5s0zdbL1vot+rnLrC",
  render_errors: [view: TimeManagerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TimeManager.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :joken, default_signer: "t1m3m4n4g3r"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
