defmodule TimeManagerWeb.AuthController do
    use TimeManagerWeb, :controller
    
    alias TimeManager.Token
    alias TimeManager.Auth

    action_fallback TimeManagerWeb.FallbackController

    def login(conn, params) do
        user = List.last(Auth.get_user_login(params["auth"]["username"], params["auth"]["password"]))
        if (is_nil(user)) do
            render(conn, "token.json", %{status: false, token: "", user: nil})
        else
            token = Token.generate_and_sign!( %{"user" => user.id, "perm" => user.roleid})
            render(conn, "token.json", %{status: true, token: token, user: user.id})
        end
    end
end