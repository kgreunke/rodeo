defmodule RodeoWeb.PageController do
  use RodeoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
