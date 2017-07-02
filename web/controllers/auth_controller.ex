defmodule UltraSonicPi.AuthController do
  use UltraSonicPi.Web, :controller

  @salt Application.get_env(:ultra_sonic_pi, :auth_salt)

  def authenticate(conn, %{"user" => %{"username" => username}})
  when not username in ["", nil] do
    token = Phoenix.Token.sign(conn, @salt, username)

    conn
    |> put_session(:user_token, token)
    |> put_flash(:info, "Successfully signed in")
    |> redirect(to: song_path(conn, :index))
  end

  def authenticate(conn, _) do
    conn
    |> put_flash(:error, "Please provide a username")
    |> render("sign_in.html")
  end

  def sign_in(conn, _) do
    conn |> render("sign_in.html")
  end

  def logout(conn, _) do
    conn
    |> put_session(:user_token, nil)
    |> assign(:username, nil)
    |> assign(:user_token, nil)
    |> put_flash(:info, "Successfully signed out")
    |> render("sign_in.html")
  end
end
