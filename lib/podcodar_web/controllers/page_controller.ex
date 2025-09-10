defmodule PodcodarWeb.PageController do
  use PodcodarWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
