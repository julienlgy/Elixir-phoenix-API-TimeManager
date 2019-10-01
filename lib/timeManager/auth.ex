defmodule TimeManager.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """


  def list_users(params) do
    IO.inspect(params)
    query = from u in User
    if (params["email"]) do
      query = from u in User, where: u.email == ^params["email"]
      if (params["username"]) do
        query = from u in User, where: u.email == ^params["email"], where: u.username == ^params["username"]
        Repo.all(query)
      else
        Repo.all(query)
      end
    else
      if (params["username"]) do
        query = from u in User, where: u.username == ^params["username"]
        Repo.all(query)
      else
        Repo.all(query)
      end
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_login(username, password) do
    password = Base.encode16(:crypto.hash(:sha256,  "#{password}_s3cr3tp4s$xXxX_______try_to_crack_this_lol"))
    query = from u in User, where: u.username == ^username, where: u.password == ^password
    Repo.all(query)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    npass = is_nil(attrs["password"]) && attrs.password || attrs["password"]
    password = Base.encode16(:crypto.hash(:sha256,  "#{npass}_s3cr3tp4s$xXxX_______try_to_crack_this_lol"))
    %User{}
    |> User.changeset(attrs)
    |> User.changeset(%{password: password})
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    password = if (!is_nil(attrs["password"])), do: Base.encode16(:crypto.hash(:sha256,  "#{attrs["password"]}_s3cr3tp4s$xXxX_______try_to_crack_this_lol")), else: nil
    user
    |> User.changeset(attrs)
    |> Repo.update()
    if (!is_nil(password)) do
      user
      |> User.changeset(user, %{password: password})
      |> Repo.update()
    end
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias TimeManager.Auth.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)
  def get_clock_by_user!(id) do
    #Repo.get_by!(Clock, [user: id])
    query = from c in Clock, where: c.user == ^id
    Repo.all(query)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def create_clock_for_user(id, attrs \\ %{}) do
    cuser = %{time: attrs["time"], status: attrs["status"], user: id}
    %Clock{}
    |> Clock.changeset(cuser)
    |> Repo.insert()
  end

  def check_endclock_create_workingtime(clock) do
    if (clock.status == true) do
      user = clock.user
      query = from c in Clock, where: c.user == ^user, where: c.status == true, order_by: c.time
      last_clocks = Repo.all(query)
      last_clock = List.first(last_clocks)
      startClock = last_clock.time
      endClock = clock.time
      if (clock != last_clock) do
        nParams = %{time: last_clock.time, status: false, user: last_clock.user}
        last_clock
        |> Clock.changeset(nParams)
        |> Repo.update()
        nParams = %{time: clock.time, status: false, user: clock.user}
        clock
        |> Clock.changeset(nParams)
        |> Repo.update()
        create_auto_workingtime(clock.user, startClock, endClock)
      end
    end
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{source: %Clock{}}

  """
  def change_clock(%Clock{} = clock) do
    Clock.changeset(clock, %{})
  end

  alias TimeManager.Auth.Workingtime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%Workingtime{}, ...]

  """
  def list_workingtimes do
    Repo.all(Workingtime)
  end

  def list_workingtimes(params) do
    if (params["start"]) do
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.start >= ^params["start"], where: w.end <= ^params["end"])
      else
        Repo.all(from w in Workingtime, where: w.start >= ^params["start"])
      end
    else
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.end <= ^params["end"])
      else
        Repo.all(Workingtime)
      end
    end

  end

  @doc """
  Gets a single workingtime.

  Raises `Ecto.NoResultsError` if the Workingtime does not exist.

  ## Examples

      iex> get_workingtime!(123)
      %Workingtime{}

      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  def get_workingtime_by_user!(id) do
      query = from w in Workingtime, where: w.user == ^id
      Repo.all(query)
  end

  def get_workingtime_by_user!(id, params) do
    if (params["start"]) do
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.user == ^id, where: w.start >= ^params["start"], where: w.end <= ^params["end"])
      else
        Repo.all(from w in Workingtime, where: w.user == ^id, where: w.start >= ^params["start"])
      end
    else
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.user == ^id, where: w.end <= ^params["end"])
      else
        Repo.all(from w in Workingtime, where: w.user == ^id)
      end
    end
  end

  @doc """
  Creates a workingtime.

  ## Examples

      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}

      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  def create_workingtime_for_user(id, attrs \\ %{}) do
    wuser = %{start: attrs["start"], end: attrs["end"], user: id}
    %Workingtime{}
    |> Workingtime.changeset(wuser)
    |> Repo.insert()
    #%Workingtime{}
    #|> Workingtime.changeset(attrs)
  end

  def create_auto_workingtime(userId, clockStart, clockEnd) do
    obj = %{start: clockStart, end: clockEnd, user: userId}
    %Workingtime{}
    |> Workingtime.changeset(obj)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.

  ## Examples

      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}

      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Workingtime.

  ## Examples

      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}

      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.

  ## Examples

      iex> change_workingtime(workingtime)
      %Ecto.Changeset{source: %Workingtime{}}

  """
  def change_workingtime(%Workingtime{} = workingtime) do
    Workingtime.changeset(workingtime, %{})
  end

  alias TimeManager.Auth.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  alias TimeManager.Auth.Managing

  @doc """
  Returns the list of managing.

  ## Examples

      iex> list_managing()
      [%Managing{}, ...]

  """
  def list_managing do
    Repo.all(Managing)
  end

  def list_managing_user(userId) do
    query=from m in Managing, where: m.employeeId == ^userId, where: m.isManager == false
    Repo.all(query)
  end

  def list_managing_manager(managerId) do
    query=from m in Managing, where: m.employeeId == ^managerId, where: m.isManager == true
    Repo.all(query)
  end

  def list_managing_team(teamId) do
    query=from m in Managing, where: m.teamId == ^teamId
    Repo.all(query)
  end

  @doc """
  Gets a single managing.

  Raises `Ecto.NoResultsError` if the Managing does not exist.

  ## Examples

      iex> get_managing!(123)
      %Managing{}

      iex> get_managing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_managing!(id) do
    query=from m in Managing, where: m.employeeId == ^id, where: m.isManager == true
    user = Repo.all(query)
    IO.inspect(user)
    if (!is_nil(user)) do
      teams = for usr <- user, do: usr.teamId
      query=from m in Managing, where: m.teamId in ^teams, where: m.isManager == false
      Repo.all(query)
    else
      []
    end

  end

  @doc """
  Creates a managing.

  ## Examples

      iex> create_managing(%{field: value})
      {:ok, %Managing{}}

      iex> create_managing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_managing(attrs \\ %{}) do
    %Managing{}
    |> Managing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a managing.

  ## Examples

      iex> update_managing(managing, %{field: new_value})
      {:ok, %Managing{}}

      iex> update_managing(managing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_managing(%Managing{} = managing, attrs) do
    managing
    |> Managing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Managing.

  ## Examples

      iex> delete_managing(managing)
      {:ok, %Managing{}}

      iex> delete_managing(managing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_managing(%Managing{} = managing) do
    Repo.delete(managing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking managing changes.

  ## Examples

      iex> change_managing(managing)
      %Ecto.Changeset{source: %Managing{}}

  """
  def change_managing(%Managing{} = managing) do
    Managing.changeset(managing, %{})
  end

  alias TimeManager.Auth.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{source: %Team{}}

  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end
end
