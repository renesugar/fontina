defmodule FontinaWeb.PageController do
  use FontinaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
