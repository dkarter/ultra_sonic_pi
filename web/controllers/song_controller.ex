defmodule UltraSonicPi.SongController do
  use UltraSonicPi.Web, :controller

  alias UltraSonicPi.Song

  def index(conn, _params) do
    songs = Repo.all(Song)
    render conn, "index.html", songs: songs
  end

  def show(conn, %{"id" => id} = _params) do
    song = Repo.get!(Song, id)
    render conn, "show.html", song: song
  end
end
