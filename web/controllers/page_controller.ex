defmodule UltraSonicPi.PageController do
  use UltraSonicPi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
