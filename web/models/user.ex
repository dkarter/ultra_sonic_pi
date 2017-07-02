defmodule UltraSonicPi.User do
  use UltraSonicPi.Web, :model

  @salt Application.get_env(:ultra_sonic_pi, :auth_salt)

  @doc """
  Veryfies an auth token and returns a username
  or nil if unable to decrypt the auth token / expired
  """
  def verify_token(conn, token) do
    case Phoenix.Token.verify(conn, @salt, token, max_age: 1209600) do
      {:ok, username} ->
        username
      {:error, _reason} ->
        nil
    end
  end
end
