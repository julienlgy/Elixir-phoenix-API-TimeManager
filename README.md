### si vous chargez le projet :  
1) vérifier bien la connection à la DB : /config/dev.exs  
2) Migrer : mix ecto.migrate  
3) lancez le serveur [mix phx.server]
  

# TimeManager API  
  
## How to use ? (Doc personnelle)  
*USER*

    a GET method : http://localhost:4000/api/users?email=XXX&username=YYY 
	`*Retour : JSON utilisateur*`
    a GET method : http://localhost:4000/api/users/:userID
	`*Retour : JSON utilisateur*`
    a POST method : http://localhost:4000/api/users
	`*Retour : JSON utilisateurs*`
    a PUT method : http://localhost:4000/api/users/:userID
	`*Retour : JSON utilisateur*`
    a DELETE method : http://localhost:4000/api/users/:userID
	`*Retour : vide*`


*WORKING TIME*

    a GET (ALL) method : http://localhost:4000/api/workingtimes/:userID?start=XXX?end=YYY
	`Retour : JSON workingtimes de l'utilisateur, avec des conditions (Pas exact)`
	a POST method : http://localhost:4000/api/workingtimes/:userID
	`*Retour : JSON workingtime de l'utilisateur*`
    a GET (ONE) method : http://localhost:4000/api/workingtimes/:userID/:workingtimeID
	`Retour : JSON workingtime spécifique de l'utilisateur`
    a PUT method : http://localhost:4000/api/workingtimes/:id
	`Retour : JSON workingtime modifié`
    a DELETE method : http://localhost:4000/api/workingtimes/:id
	` Retour : vide`
*CLOCKING

    a GET method : http://localhost:4000/api/clocks/ 
	`Retour : JSON clocks : toute les clocks`
    a GET method : http://localhost:4000/api/clocks/:userID
	`Retour : JSSON clocks de l'utilisateur`
    a POST method : http://localhost:4000/api/clocks/:userID 
	`= POINTAGE : on POST pas de status false, mais forcément TRUE, au bout de 2 TRUE l'API créée automatiquement un workingtimes.

## PERMISSION LIST
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
            #ROLES
            "GET_api_roles_own" => 4,
            "POST_api_roles" => 4,
            "PUT_api_roles_id" => 4,
            "PUT_api_roles_team" => 4,
            "PUT_api_roles_own" => 4,
            "DELETE_api_roles_id" => 4,
            "DELETE_api_roles_team" => 4,
            "DELETE_api_roles_own" => 4
        }


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
