defmodule RestapiTest do
  use ExUnit.Case
  import Plug.Test
  import Ecto.Query, only: [from: 2]
  use MyPlug, :database

  @opts MyRouter.init([])
  test "GET /" do
    conn = conn(:get, "/")
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 200
    assert conn.resp_body == "hello!"
  end

  test "GET /:message" do
    conn = conn(:get, "/hello")
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 200
    assert conn.resp_body == "hello"
  end

  test "POST /user/login" do
    conn = conn(:post, "/user/login", %{"name" => "test", "password" => "1234"})
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 200
    assert conn.resp_body == "Hello, your name test, password 1234"
  end

  test "POST /user/login missing name" do
    conn = conn(:post, "/user/login", %{"password" => "1234"})
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 400
    assert conn.resp_body == "Missing name"
  end

  test "POST /user/login missing password" do
    conn = conn(:post, "/user/login", %{"name" => "test"})
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 400
    assert conn.resp_body == "Missing password"
  end

  test "POST /user/login missing both" do
    conn = conn(:post, "/user/login", %{})
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 400
    assert conn.resp_body == "Missing name and password"
  end

  test "GET /user" do
    conn = conn(:get, "/user")
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 200
    assert conn.resp_body == "user"
  end

  test "GET /user/:id" do
    conn = conn(:get, "/user/1")
    conn = MyRouter.call(conn, @opts)
    user = PG.get(User, 1)
    assert conn.status == 200
    assert conn.resp_body == "User: #{user.name}, #{user.email}, #{user.age}"
  end

  test "GET 404 /user/:id" do
    conn = conn(:get, "/user/-1")
    conn = MyRouter.call(conn, @opts)
    assert conn.status == 404
    assert conn.resp_body == "User not found"
  end

  test "Ecto Query" do
    # Assuming you have a Repo module and User schema defined

    # Example query to fetch users older than 18 or with no email
    query =
      from(u in User,
        where: u.age > 18 or is_nil(u.email),
        select: u
      )

    # Returns %User{} structs matching the query
    PG.all(query)
  end

  test "POST /user/register" do
    conn =
      conn(:post, "/user/register", %{
        "name" => "test",
        "password" => "1234",
        "email" => "example@gmail.com",
        "age" => 25
      })

    conn = MyRouter.call(conn, @opts)
    assert conn.status == 400
  end
end
