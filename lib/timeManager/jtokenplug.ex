defmodule TimeManager.JwtAuthPlug do
    import Plug.Conn

    alias TimeManager.Token
    alias TimeManager.Permission

    def init(opts), do: opts

    def call(conn, _opts) do
        token = jwt_from_header(conn)
        case Token.verify_and_validate(token) do
            {:ok, claims} ->
            conn 
            |> success(claims, token)
            |> Permission.hasPermission
            { :error, _error } ->
            conn |> forbidden
        end
    end

    defp jwt_from_header(conn) do
        temptoken = List.last(get_req_header(conn, "session_jwt"))
        if (is_nil(temptoken)) do
            ""
        else
            temptoken
        end
    end

    defp success(conn, token_payload, token) do
        assign(conn, :perm, token_payload["perm"])
        |> assign(:user, token_payload["user"])
        |> assign(:jwt, token)
    end

    defp forbidden(conn) do
        conn
        |> put_resp_header("Content-Type", "application/json")
        |> send_resp(403, "{ \"error\": \"Not Authorized\"}")
        |> halt
    end
end