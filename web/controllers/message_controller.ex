defmodule UltraSonicPi.MessageController do
  use UltraSonicPi.Web, :controller

  alias UltraSonicPi.Message
  alias UltraSonicPi.Song

  plug :find_song

  def index(conn, _params) do
    song = conn.assigns.song
    messages = Repo.all(from m in assoc(song, :messages))
    render(conn, "index.html", messages: messages)
  end

  def new(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    song = conn.assigns.song
    changeset =
      song
      |> Ecto.Model.build(:messages)
      |> Message.changeset(message_params)

    case Repo.insert(changeset) do
      {:ok, _message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: song_message_path(conn, :index, song))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp find_song(conn, _) do
    assign(conn, :song, Repo.get!(Song, conn.params["song_id"]))
  end
end
