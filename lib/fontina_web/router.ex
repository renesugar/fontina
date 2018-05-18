defmodule FontinaWeb.Router do
  use FontinaWeb, :router

  alias Fontina.Helper.Auth, as: AuthHelper

  # TODO: Fix error handling here
  def no_auth_or_redirect(conn, loc) do
    case AuthHelper.authorize_for_resource(conn) do
      nil                 -> conn
      {:ok, current_user} -> assign(conn, :current_user, current_user) |> redirect([to: loc]) |> halt
      :ok                 -> conn |> redirect([to: loc]) |> halt
      {:error, _}         -> conn |> redirect([to: "/"]) |> halt
    end
  end

  def auth_or_redirect(conn, loc) do
    case AuthHelper.authorize_for_resource(conn) do
      nil                 -> conn |> redirect([to: loc]) |> halt
      {:ok, current_user} -> assign(conn, :current_user, current_user)
      :ok                 -> conn
      {:error, _}         -> conn |> redirect([to: "/"]) |> halt
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :noauth do
    plug :no_auth_or_redirect, "/timeline"
  end

  pipeline :auth do
    plug :auth_or_redirect, "/login"
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", FontinaWeb, as: :b do
    pipe_through :browser

    get  "/",             PageController, :index

    get "/about",         PageController, :about
    get "/about/more",    PageController, :more

    get "/@:name",        UserController, :user_by_name
    get "/user/:uuid",    UserController, :user_by_uuid
    
    # Okay, so this should work. Just define post and post_hilite_reply twice, once with %{"name" => name} and once with %{"uuid" => uuid}
    # I'm not good enough with Elixir to say it'll 100% work, but it definitely seems like it should
    get "/@:name/:id",      PostController, :post
    get "/@:name/:id/:rid", PostController, :post_hilite_reply

    get "/user/:uuid/:id",      PostController, :post
    get "/user/:uuid/:id/:rid", PostController, :post_hilite_reply
  end

  scope "/", FontinaWeb.NoAuth, as: :b_noauth do
    pipe_through [:browser, :noauth]

    # No need to see login or register when you're already logged in
    get  "/login",    UserController, :login
    post "/login",    UserController, :login_post
    get  "/register", UserController, :register
    post "/register", UserController, :register_post
  end

  scope "/", FontinaWeb.Auth, as: :b_auth do
    pipe_through [:browser, :auth]

    # Most settings changed by just posting to /me/settings, but password has to be changed on a special page
    get  "/me",                   UserController, :self_redirect
    get  "/me/settings",          UserController, :settings
    post "/me/settings",          UserController, :settings_post
    get  "/me/settings/password", UserController, :pw
    post "/me/settings/password", UserController, :pw_post

    get  "/post/new",             PostController, :post_new
    post "/post/new",             PostController, :post_new_post

    # See above with defining reply_new_post twice
    post "/user/:uuid/:id/reply", PostController, :reply_new_post
    post "/@:name/:id/reply",     PostController, :reply_new_post

    get  "/timeline",             FeedController, :followed_timeline
    get  "/timeline/local",       FeedController, :local_timeline
    get  "/timeline/global",      FeedController, :global_timeline

    post "/logout",               UserController, :logout_post

    # XXX: Temporary, remove later
    get  "/logout",               UserController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", FontinaWeb do
  #   pipe_through :api
  # end
end
