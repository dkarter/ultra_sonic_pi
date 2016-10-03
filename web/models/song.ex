defmodule UltraSonicPi.Song do
  use UltraSonicPi.Web, :model

  schema "songs" do
    field :body, :string
    field :title, :string
    has_many :messages, UltraSonicPi.Message

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :title])
    |> validate_required([:body, :title])
    |> validate_length(:title, min: 3)
  end
end
