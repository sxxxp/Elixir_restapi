defmodule MyRouter.UserRouter do
  @moduledoc """
  /user router

  """

  use Router, :router
  use MyPlug, :database

  get "/" do
    send_resp(conn, 200, "hello user!")
  end

  get "/:id" do
    user = PG.get(User, id)

    case user do
      %User{} ->
        send_resp(conn, 200, "User: #{user.name}, #{user.email}, #{user.age}")

      nil ->
        send_resp(conn, 404, "User not found")
    end
  end

  post "/login" do
    case [name, password] = extract_params(conn.params, ["name", "password"]) do
      [nil, nil] ->
        send_resp(conn, 400, "Missing name and password")

      [nil, _] ->
        send_resp(conn, 400, "Missing name")

      [_, nil] ->
        send_resp(conn, 400, "Missing password")

      [_, _] ->
        send_resp(conn, 200, "Hello, your name #{name}, password #{password}")
    end
  end

  post "/register" do
    case [name, password, email, age] =
           extract_params(conn.params, ["name", "password", "email", "age"]) do
      [nil, _, _, _] ->
        send_resp(conn, 400, "Missing name")

      [_, nil, _, _] ->
        send_resp(conn, 400, "Missing password")

      [_, _, nil, _] ->
        send_resp(conn, 400, "Missing email")

      [_, _, _, _] ->
        params = %{name: name, email: email, password: password, age: age}
        changeset = User.changeset(%User{}, params)
        user = PG.insert(changeset)

        case user do
          {:ok, user} ->
            send_resp(conn, 200, "User created: #{user.name}, #{user.email}, #{user.age}")

          {:error, changeset} ->
            send_resp(conn, 400, "Error creating user: #{inspect(changeset.errors)}")
        end
    end
  end
end
