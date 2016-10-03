defmodule UltraSonicPi.Router do
  use UltraSonicPi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :socket do
  end

  scope "/", UltraSonicPi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    # get "/songs/:id", SongController, :show
    # get "/songs", SongController, :index

    resources "/songs", SongController do
      resources "/messages", MessageController, only: [:index, :new, :create]
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", UltraSonicPi do
  #   pipe_through :api
  # end
end
