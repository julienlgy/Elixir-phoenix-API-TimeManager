defmodule TimeManagerWeb.ManagingControllerTest do
  use TimeManagerWeb.ConnCase

  alias TimeManager.Auth
  alias TimeManager.Auth.Managing

  @create_attrs %{
    isManager: true
  }
  @update_attrs %{
    isManager: false
  }
  @invalid_attrs %{isManager: nil}

  def fixture(:managing) do
    {:ok, managing} = Auth.create_managing(@create_attrs)
    managing
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all managing", %{conn: conn} do
      conn = get(conn, Routes.managing_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create managing" do
    test "renders managing when data is valid", %{conn: conn} do
      conn = post(conn, Routes.managing_path(conn, :create), managing: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.managing_path(conn, :show, id))

      assert %{
               "id" => id,
               "isManager" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.managing_path(conn, :create), managing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update managing" do
    setup [:create_managing]

    test "renders managing when data is valid", %{conn: conn, managing: %Managing{id: id} = managing} do
      conn = put(conn, Routes.managing_path(conn, :update, managing), managing: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.managing_path(conn, :show, id))

      assert %{
               "id" => id,
               "isManager" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, managing: managing} do
      conn = put(conn, Routes.managing_path(conn, :update, managing), managing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete managing" do
    setup [:create_managing]

    test "deletes chosen managing", %{conn: conn, managing: managing} do
      conn = delete(conn, Routes.managing_path(conn, :delete, managing))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.managing_path(conn, :show, managing))
      end
    end
  end

  defp create_managing(_) do
    managing = fixture(:managing)
    {:ok, managing: managing}
  end
end
