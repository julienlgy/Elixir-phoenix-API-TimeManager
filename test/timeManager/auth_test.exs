defmodule TimeManager.AuthTest do
  use TimeManager.DataCase

  alias TimeManager.Auth

  describe "users" do
    alias TimeManager.Auth.User

    @valid_attrs %{email: "some email", username: "some username"}
    @update_attrs %{email: "some updated email", username: "some updated username"}
    @invalid_attrs %{email: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "clocks" do
    alias TimeManager.Auth.Clock

    @valid_attrs %{status: true, time: "2010-04-17T14:00:00Z"}
    @update_attrs %{status: false, time: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{status: nil, time: nil}

    def clock_fixture(attrs \\ %{}) do
      {:ok, clock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_clock()

      clock
    end

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Auth.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Auth.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      assert {:ok, %Clock{} = clock} = Auth.create_clock(@valid_attrs)
      assert clock.status == true
      assert clock.time == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{} = clock} = Auth.update_clock(clock, @update_attrs)
      assert clock.status == false
      assert clock.time == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_clock(clock, @invalid_attrs)
      assert clock == Auth.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Auth.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Auth.change_clock(clock)
    end
  end

  describe "workingtimes" do
    alias TimeManager.Auth.Workingtime

    @valid_attrs %{end: "2010-04-17T14:00:00Z", start: "2010-04-17T14:00:00Z"}
    @update_attrs %{end: "2011-05-18T15:01:01Z", start: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{end: nil, start: nil}

    def workingtime_fixture(attrs \\ %{}) do
      {:ok, workingtime} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_workingtime()

      workingtime
    end

    test "list_workingtimes/0 returns all workingtimes" do
      workingtime = workingtime_fixture()
      assert Auth.list_workingtimes() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert Auth.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      assert {:ok, %Workingtime{} = workingtime} = Auth.create_workingtime(@valid_attrs)
      assert workingtime.end == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert workingtime.start == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{} = workingtime} = Auth.update_workingtime(workingtime, @update_attrs)
      assert workingtime.end == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert workingtime.start == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == Auth.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = Auth.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = Auth.change_workingtime(workingtime)
    end
  end

  describe "roles" do
    alias TimeManager.Auth.Role

    @valid_attrs %{name: "some name", permission: 42}
    @update_attrs %{name: "some updated name", permission: 43}
    @invalid_attrs %{name: nil, permission: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Auth.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Auth.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Auth.create_role(@valid_attrs)
      assert role.name == "some name"
      assert role.permission == 42
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Auth.update_role(role, @update_attrs)
      assert role.name == "some updated name"
      assert role.permission == 43
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_role(role, @invalid_attrs)
      assert role == Auth.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Auth.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Auth.change_role(role)
    end
  end

  describe "managing" do
    alias TimeManager.Auth.Managing

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def managing_fixture(attrs \\ %{}) do
      {:ok, managing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_managing()

      managing
    end

    test "list_managing/0 returns all managing" do
      managing = managing_fixture()
      assert Auth.list_managing() == [managing]
    end

    test "get_managing!/1 returns the managing with given id" do
      managing = managing_fixture()
      assert Auth.get_managing!(managing.id) == managing
    end

    test "create_managing/1 with valid data creates a managing" do
      assert {:ok, %Managing{} = managing} = Auth.create_managing(@valid_attrs)
    end

    test "create_managing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_managing(@invalid_attrs)
    end

    test "update_managing/2 with valid data updates the managing" do
      managing = managing_fixture()
      assert {:ok, %Managing{} = managing} = Auth.update_managing(managing, @update_attrs)
    end

    test "update_managing/2 with invalid data returns error changeset" do
      managing = managing_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_managing(managing, @invalid_attrs)
      assert managing == Auth.get_managing!(managing.id)
    end

    test "delete_managing/1 deletes the managing" do
      managing = managing_fixture()
      assert {:ok, %Managing{}} = Auth.delete_managing(managing)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_managing!(managing.id) end
    end

    test "change_managing/1 returns a managing changeset" do
      managing = managing_fixture()
      assert %Ecto.Changeset{} = Auth.change_managing(managing)
    end
  end

  describe "user" do
    alias TimeManager.Auth.Users

    @valid_attrs %{email: "some email", password: "some password", username: "some username"}
    @update_attrs %{email: "some updated email", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def users_fixture(attrs \\ %{}) do
      {:ok, users} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_users()

      users
    end

    test "list_user/0 returns all user" do
      users = users_fixture()
      assert Auth.list_user() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Auth.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      assert {:ok, %Users{} = users} = Auth.create_users(@valid_attrs)
      assert users.email == "some email"
      assert users.password == "some password"
      assert users.username == "some username"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      assert {:ok, %Users{} = users} = Auth.update_users(users, @update_attrs)
      assert users.email == "some updated email"
      assert users.password == "some updated password"
      assert users.username == "some updated username"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_users(users, @invalid_attrs)
      assert users == Auth.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Auth.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Auth.change_users(users)
    end
  end

  describe "users" do
    alias TimeManager.Auth.User

    @valid_attrs %{email: "some email", password: "some password", username: "some username"}
    @update_attrs %{email: "some updated email", password: "some updated password", username: "some updated username"}
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "teams" do
    alias TimeManager.Auth.Team

    @valid_attrs %{color: "some color", name: "some name"}
    @update_attrs %{color: "some updated color", name: "some updated name"}
    @invalid_attrs %{color: nil, name: nil}

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_team()

      team
    end

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Auth.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Auth.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, %Team{} = team} = Auth.create_team(@valid_attrs)
      assert team.color == "some color"
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      assert {:ok, %Team{} = team} = Auth.update_team(team, @update_attrs)
      assert team.color == "some updated color"
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_team(team, @invalid_attrs)
      assert team == Auth.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Auth.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Auth.change_team(team)
    end
  end

  describe "managing" do
    alias TimeManager.Auth.Managing

    @valid_attrs %{isManager: true}
    @update_attrs %{isManager: false}
    @invalid_attrs %{isManager: nil}

    def managing_fixture(attrs \\ %{}) do
      {:ok, managing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_managing()

      managing
    end

    test "list_managing/0 returns all managing" do
      managing = managing_fixture()
      assert Auth.list_managing() == [managing]
    end

    test "get_managing!/1 returns the managing with given id" do
      managing = managing_fixture()
      assert Auth.get_managing!(managing.id) == managing
    end

    test "create_managing/1 with valid data creates a managing" do
      assert {:ok, %Managing{} = managing} = Auth.create_managing(@valid_attrs)
      assert managing.isManager == true
    end

    test "create_managing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_managing(@invalid_attrs)
    end

    test "update_managing/2 with valid data updates the managing" do
      managing = managing_fixture()
      assert {:ok, %Managing{} = managing} = Auth.update_managing(managing, @update_attrs)
      assert managing.isManager == false
    end

    test "update_managing/2 with invalid data returns error changeset" do
      managing = managing_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_managing(managing, @invalid_attrs)
      assert managing == Auth.get_managing!(managing.id)
    end

    test "delete_managing/1 deletes the managing" do
      managing = managing_fixture()
      assert {:ok, %Managing{}} = Auth.delete_managing(managing)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_managing!(managing.id) end
    end

    test "change_managing/1 returns a managing changeset" do
      managing = managing_fixture()
      assert %Ecto.Changeset{} = Auth.change_managing(managing)
    end
  end
end
