defmodule Fontina.Helper.Auth do
  import Plug.Conn
  
  alias Fontina.{Repo,User,Token}
  
  # TODO: Error better
  def authorize_for_resource(%{assigns: %{current_user: user}} = conn),
    do: :ok

  def authorize_for_resource(conn) do
    with token when not is_nil(token) <- get_session(conn, :session_token),
         %Token{user_id: user_id} <- Repo.get_by(Token, value: token),
         %User{} = user <- Repo.get!(User, user_id) do
      {:ok, user}
    else
      _e -> nil
    end
  end
end
