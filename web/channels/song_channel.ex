defmodule UltraSonicPi.SongChannel do
  use UltraSonicPi.Web, :channel

  def join("songs:" <> song_id, _params, socket) do
    {:ok, assign(socket, :song_id, song_id)}
  end

  def handle_in("text_change", %{"changes" => changes}, socket) do
    broadcast_from!(socket, "text_change", %{
      changes: changes,
      author: socket.assigns.username
    })

    {:reply, :ok, socket}
  end

  def handle_in("cursor_change", %{"cursor" => cursor}, socket) do
    broadcast_from!(socket, "cursor_change", %{
      cursor: cursor,
      author: socket.assigns.username
    })

    {:reply, :ok, socket}
  end

  def handle_in("play", _body, socket) do
    # use osc protocol wrapper to send body to sonic pi
    # see https://github.com/jwarwick/ex_osc
    # and https://github.com/samaaron/sonic-pi/wiki/Sonic-Pi-Internals----GUI-Ruby-API
    {:reply, :ok, socket}
  end
end
