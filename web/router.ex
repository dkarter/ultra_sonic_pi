defmodule UltraSonicPi.Router do
  use UltraSonicPi.Web, :router

  use ExAdmin.Router
  # your app's routes
  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes()
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :authenticated_routes do
    plug :require_authentication
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :socket do
  end

  scope "/", UltraSonicPi do
    pipe_through :browser

    get "/", PageController, :index

    post "/sign_in", AuthController, :authenticate
    get "/sign_in", AuthController, :sign_in
    get "/logout", AuthController, :logout, as: :logout
  end

  scope "/", UltraSonicPi do
    pipe_through [:browser, :authenticated_routes]

    resources "/songs", SongController do
      resources "/messages", MessageController, only: [:index, :new, :create]
    end
  end

  defp put_user_token(conn, _) do
    token = get_session(conn, "user_token")
    username = UltraSonicPi.User.verify_token(conn, token)

    conn
    |> assign(:user_token, token)
    |> assign(:username, username)
  end

  defp require_authentication(conn, _) do
    token = get_session(conn, "user_token")
    username = UltraSonicPi.User.verify_token(conn, token)

    if username do
      conn
    else
      conn
      |> put_flash(:info, "You must sign in to view this page")
      |> redirect(to: "/sign_in")
      |> halt()
    end
  end
end
