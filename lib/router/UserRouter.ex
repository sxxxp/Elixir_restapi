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
    id = Integer.parse(id)

    case id do
      :error ->
        send_resp(conn, 400, "Invalid ID format")

      {id, ""} ->
        user = PG.get(User, id)

        case user do
          %User{} ->
            send_resp(conn, 200, "User: #{user.name}, #{user.email}")

          nil ->
            send_resp(conn, 404, "User not found")
        end
    end
  end

  post "/login" do
    case [email, password] = extract_params(conn.params, ["email", "password"]) do
      [nil, nil] ->
        send_resp(conn, 400, "Missing email and password")

      [nil, _] ->
        send_resp(conn, 400, "Missing email")

      [_, nil] ->
        send_resp(conn, 400, "Missing password")

      [_, _] ->
        user = PG.get_by(User, email: email)

        case user do
          %User{} ->
            if User.verify_password(password, user.password_hash) do
              send_resp(
                conn,
                200,
                MyUtil.keyword_to_json(
                  name: user.name,
                  email: user.email
                )
              )
            else
              send_resp(conn, 401, "Invalid password")
            end

          nil ->
            send_resp(conn, 404, "User not found")
        end
    end
  end

  post "/register" do
    case [name, password, email] =
           extract_params(conn.params, ["name", "password", "email"]) do
      [nil, _, _, _] ->
        send_resp(conn, 400, "Missing name")

      [_, nil, _, _] ->
        send_resp(conn, 400, "Missing password")

      [_, _, nil, _] ->
        send_resp(conn, 400, "Missing email")

      [_, _, _, _] ->
        params = %{name: name, email: email, password: password}
        changeset = User.changeset(%User{}, params)
        user = PG.insert(changeset)

        case user do
          {:ok, user} ->
            send_resp(conn, 200, MyUtil.keyword_to_json(%{name: user.name, email: user.email}))

          {:error, changeset} ->
            case changeset.errors[0] do
              {"has already been taken", _} ->
                send_resp(conn, 409, "이미 유저가 존재합니다.")

              {_, _} ->
                ErrorLogger.elog("MyRouter.UserRouter", "유저 생성에 실패했습니다.")
                send_resp(conn, 500, "유저 생성에 실패했습니다.")
            end
        end
    end
  end
end
