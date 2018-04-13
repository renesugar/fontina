defmodule FontinaWeb.NoAuth.UserController do
  use FontinaWeb, :controller

  alias Fontina.Policy.Login,    as: LoginPolicy
  alias Fontina.Policy.Register, as: RegisterPolicy

  def login(conn, _) do
    render conn, "login.html"
  end

  def login_post(conn, %{"user" => %{"email" => email, "password" => password} = user_params} = _) 
      when is_binary(email) and is_binary(password) do
    case LoginPolicy.process(user_params) do
      {:ok, %{"user" => user, "token" => token} = _res} ->
        conn
        |> assign(:current_user, user)
        |> fetch_session
        |> put_session(:session_token, token.value)
        |> configure_session(renew: true) 
        |> redirect(to: "/timeline")
      {:error, {_status, _errors}} ->
        redirect(conn, to: "/")
    end
  end

  def login_post(conn, _),
    do: redirect(conn, to: "/login")


  def register(conn, _) do
    render conn, "register.html"
  end

  def register_post(conn, %{"user" => %{"email" => _, "password" => _} = user_params} = params) do
    case RegisterPolicy.process(user_params) do
      {:ok, _} -> login_post(conn, params)
      {:error, {_status, _errors}} ->
        redirect(conn, to: "/")
    end
  end

  def register_post(conn, _),
    do: redirect(conn, to: "/register")
end
