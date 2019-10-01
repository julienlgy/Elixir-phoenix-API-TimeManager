defmodule TimeManagerWeb.AuthView do
  use TimeManagerWeb, :view

  def render("token.json", %{status: status, token: token, user: user}) do
    %{status: status, token: token, user: user}
  end
end
