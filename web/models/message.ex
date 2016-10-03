defmodule UltraSonicPi.Message do
  use UltraSonicPi.Web, :model

  schema "messages" do
    field :body, :string
    belongs_to :song, UltraSonicPi.Song

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end
end
