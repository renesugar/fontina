defmodule Fontina.Policy.Logout do

  alias Authable.Model.Token
  
  @repo Application.get_env(:authable, :repo)

  def process(params) do
    params
    |> delete_session()
  end

  defp delete_session(%{"token_value" => token_value}) do
    token = @repo.get_by!(Token, name: "session_token", value: token_value)

    @repo.delete!(token)
  end
end
