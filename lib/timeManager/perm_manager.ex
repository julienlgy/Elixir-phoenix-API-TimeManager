defmodule TimeManager.Permission do
    import Plug.Conn

    alias TimeManager.Auth

    def hasPermission(conn) do
        method = conn.method
        userid = conn.assigns.user
        managedid = Auth.get_managing!(userid) 
        perm = conn.assigns.perm
        paths = for path <- conn.path_info do
            case Integer.parse(path) do
                {integer, ""} -> if (integer == userid), do: "own", else: if (Enum.find(managedid, fn map -> map.employeeId == integer end)), do: "team", else: "id"
                _ -> path
            end
        end
        
        perms_needed =  method <> "_"  <> Enum.join(paths, "_")

        IO.inspect(perms_needed)
        IO.inspect(perm)
        has_perm = check_permission(perms_needed, perm)
        
        if (has_perm), do: conn, else: conn |> forbidden
    end

    defp check_permission(perms_needed, perm) do
        IO.inspect(perms()[perms_needed])
        if (is_nil(perms()[perms_needed])) do
            IO.puts("not found")
            perm == 3
        else
            IO.puts(" needing : #{perms()[perms_needed]}")
            perm >= perms()[perms_needed]
        end
    end


    # 1. employee and more
    # 2. manager and more
    # 3. general-manager and more (default id not found)
    # 4. administrator / webmaster only
    defp perms do
        %{
            #CLOCKS
            "GET_api_clocks_own" => 1,
            "GET_api_clocks_id" => 3,
            "GET_api_clocks_team" => 2,
            "POST_api_clocks_own" => 1,
            "POST_api_clocks_id" => 3,
            "POST_api_clocks_team" => 3,
            # USERS
            "GET_api_users" => 3,
            "GET_api_users_own" => 1,
            "GET_api_users_team" => 2,
            "GET_api_users_id" => 3,
            "POST_api_users" => 3,
            "PUT_api_users_own" => 1,
            "PUT_api_users_team" => 3,
            "PUT_api_users_id" => 3,
            "DELETE_api_users_own" => 1,
            "DELETE_api_users_team" => 3,
            "DELETE_api_users_id" => 3,
            # WORKINGTIMES
            "GET_api_workingtimes_own" => 1,
            "GET_api_workingtimes_own_id" => 1,
            "GET_api_workingtimes_own_own" => 1,
            "GET_api_workingtimes_own_team" => 1,
            "GET_api_workingtimes_team" => 2,
            "GET_api_workingtimes_id" => 3,
            "POST_api_workingtimes_own" => 2,
            "POST_api_workingtimes_team" => 2,
            "POST_api_workingtimes_id" => 3,
            "PUT_api_workingtimes_own" => 2,
            "PUT_api_workingtimes_team" => 2,
            "PUT_api_workingtimes_id" => 3,
            "DELETE_api_workingtimes_own" => 2,
            "DELETE_api_workingtimes_team" => 2,
            "DELETE_api_workingtimes_id" => 3,
            #MANAGING (DEFAULT OK : GENERAL MANAGER ONLY)
            "GET_api_managing_own" => 2,
            "GET_api_managing_team_id" => 1,
            "GET_api_managing_team_own" => 1,
            "GET_api_managing_team_team" => 1,
            "GET_api_managing_user_id" => 3,
            "GET_api_managing_user_own" => 1,
            "GET_api_managing_user_team" => 2,
            "GET_api_managing_manager_id" => 3,
            "GET_api_managing_manager_team" => 2,
            "GET_api_managing_manager_own" => 1,
            #ROLES
            "GET_api_roles_own" => 4,
            "POST_api_roles" => 4,
            "PUT_api_roles_id" => 4,
            "PUT_api_roles_team" => 4,
            "PUT_api_roles_own" => 4,
            "DELETE_api_roles_id" => 4,
            "DELETE_api_roles_team" => 4,
            "DELETE_api_roles_own" => 4,
            #TEAMS
            "GET_api_teams" => 2,
            "GET_api_teams_id" => 2,
            "GET_api_teams_own" => 2
        }
    end

    defp forbidden(conn) do
        conn
        |> put_resp_header("Content-Type", "application/json")
        |> send_resp(403, "{ \"error\": \"Not Authorized\"}")
        |> halt
    end
end