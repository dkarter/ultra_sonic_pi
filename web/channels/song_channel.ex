defmodule UltraSonicPi.SongChannel do
  use UltraSonicPi.Web, :channel

  def join("songs:" <> song_id, params, socket) do
    {:ok, assign(socket, :song_id, song_id)}
  end

  def handle_in("text_change", %{"changes" => changes}, socket) do
    # broadcast_from - from my socket to everyone else but myself
    broadcast_from! socket, "text_change", %{changes: changes}
    {:reply, :ok, socket}
  end

  def handle_in("play", body, socket) do
    # use osc protocol wrapper to send body to sonic pi
    # see https://github.com/jwarwick/ex_osc
    # and https://github.com/samaaron/sonic-pi/wiki/Sonic-Pi-Internals----GUI-Ruby-API
    {:reply, :ok, socket}
  end
end
