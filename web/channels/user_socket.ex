defmodule UltraSonicPi.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "songs:*", UltraSonicPi.SongChannel

  ## Transports
  transport :websocket,
    Phoenix.Transports.WebSocket,
    check_origin: ["//localhost", "//127.0.0.1", "//example.com"]
  # TODO: add domain configuration for production ^^^

  def connect(%{"token" => token}, socket) do
    if username = UltraSonicPi.User.verify_token(socket, token) do
      {:ok, assign(socket, :username, username)}
    else
      :error
    end
  end

  def connect(_params, socket) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     UltraSonicPi.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
