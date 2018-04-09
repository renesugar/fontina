# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fontina,
  ecto_repos: [Fontina.Repo]

# Configures the endpoint
config :fontina, FontinaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xkHJuLpuD0rwPMajQ2PBXso+IpQKqRH9O0zCICyN0Ct5kHIWhbW8tTqJu5Ieuky0",
  render_errors: [view: FontinaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Fontina.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :authable,
  ecto_repos: [Fontina.Repo],
  repo: Fontina.Repo,
  expires_in: %{
    access_token: 3600,
    refresh_token: 24 * 3600,
    authorization_code: 300,
    session_token: 30 * 24 * 3600
  },
  grant_types: %{
    authorization_code: Authable.GrantType.AuthorizationCode,
    password: Authable.GrantType.Password,
    refresh_token: Authable.GrantType.RefreshToken
  },
  auth_strategies: %{
    headers: %{
      "authorization" => [
        {~r/Basic ([a-zA-Z\-_\+=]+)/, Authable.Authentication.Basic},
        {~r/Bearer ([a-zA-Z\-_\+=]+)/, Authable.Authentication.Bearer},
      ],
      "x-api-token" => [
        {~r/([a-zA-Z\-_\+=]+)/, Authable.Authentication.Bearer}
      ]
    },
    query_params: %{
      "access_token" => Authable.Authentication.Bearer
    },
    sessions: %{
      "session_token" => Authable.Authentication.Session
    }
  },
  scopes: ~w(read write session),
  renderer: Authable.Renderer.RestApi

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
