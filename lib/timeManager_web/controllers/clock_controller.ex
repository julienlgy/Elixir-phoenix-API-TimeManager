defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Auth
  alias TimeManager.Auth.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Auth.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Auth.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def create_for_user(conn, %{"id" => id, "clock" => clock_params}) do
    user = Auth.get_user!(id)
    IO.inspect(user)
    if (is_nil(user)) do
      conn
      |> put_status(:not_found)
      |> put_view(TimeManagerWeb.ErrorView)
      |> render(:"404")
    else
      with {:ok, %Clock{} = clock} <- Auth.create_clock_for_user(id, clock_params) do
            Auth.check_endclock_create_workingtime(clock)
            conn
            |> put_status(:created)
            |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
            |> render("show.json", clock: clock)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    clocks = Auth.get_clock_by_user!(id)
    render(conn, "index.json", clocks: clocks)
    #render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Auth.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Auth.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Auth.get_clock!(id)

    with {:ok, %Clock{}} <- Auth.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
