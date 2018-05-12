defmodule FontinaWeb.Auth.UserController do
  use FontinaWeb, :controller

  alias Fontina.Policy.Logout, as: LogoutPolicy

  def logout_post(conn, _) do
    token_value = get_session(conn, :session_token)

    LogoutPolicy.process(%{"token_value" => token_value})

    # Drop the current user
    update_in(conn.assigns, &Map.drop(&1, [:current_user]))
    |> fetch_session()
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  # XXX: Remove later
  def logout(conn, _) do
    render conn, "logout.html"
  end
end
