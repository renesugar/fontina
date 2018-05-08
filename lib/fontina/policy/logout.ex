defmodule Fontina.Policy.Logout do

  alias Fontina.{Repo, Token}

  def process(params) do
    params
    |> delete_session()
  end

  defp delete_session(%{"token_value" => token_value}) do
    token = Repo.get_by!(Token, name: "session_token", value: token_value)

    Repo.delete!(token)
  end
end
