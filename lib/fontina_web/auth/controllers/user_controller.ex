defmodule FontinaWeb.Auth.UserController do
  use FontinaWeb, :controller

  alias Fontina.Policy.Logout, as: LogoutPolicy

  def logout_post(conn, _) do
    token_value = get_session(fetch_session(conn), :session_token)

    LogoutPolicy.process(%{"token_value" => token_value})

    conn
    |> fetch_session()
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
