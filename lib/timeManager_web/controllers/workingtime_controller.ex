defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Auth
  alias TimeManager.Auth.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, params) do
    workingtimes = Auth.list_workingtimes(params)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Auth.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def create_for_user(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Auth.create_workingtime_for_user(id, workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtimes = Auth.get_workingtime_by_user!(id, conn.params)
    render(conn, "index.json", workingtimes: workingtimes)
    #render(conn, "show.json", workingtime: workingtime)
  end

  def show_one(conn, %{"id" => id, "idw" => idw}) do
    workingtimes = Auth.get_workingtime_by_user!(id)
    Enum.each workingtimes, fn workingtime -> 
      if "#{workingtime.id}" == idw do
        render(conn, "show.json", workingtime: workingtime)
      end
    end
    conn
    |> put_status(:not_found)
    |> put_view(TimeManagerWeb.ErrorView)
    |> render(:"404")
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Auth.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Auth.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Auth.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Auth.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
