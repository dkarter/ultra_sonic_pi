defmodule UltraSonicPi.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :song_id, references(:songs, on_delete: :nothing)

      timestamps()
    end
    create index(:messages, [:song_id])

  end
end
