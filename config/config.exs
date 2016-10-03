# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ultra_sonic_pi,
  ecto_repos: [UltraSonicPi.Repo]

# Configures the endpoint
config :ultra_sonic_pi, UltraSonicPi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5ko8i1ZHyWEA7dRNViTNT8cDpRYJZ5nb9NdUzbjiNtfEntQ3qQ4yh3eib5vP8i1p",
  render_errors: [view: UltraSonicPi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UltraSonicPi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
