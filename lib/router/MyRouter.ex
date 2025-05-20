defmodule MyRouter do
  use Router, :router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  use Plug.ErrorHandler

  get "/" do
    send_resp(conn, 200, "hello!")
  end

  get "/favicon.ico" do
    send_resp(conn, 200, "hello!")
  end

  get "/:message" do
    send_resp(conn, 200, "#{message}")
  end

  forward("/user", to: MyRouter.UserRouter)
  forward("/chat", to: MyRouter.ChatRouter)
  forward("/ws", to: MyRouter.SocketRouter)

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  # defp handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
  #   IO.inspect(_kind)
  #   send_resp(conn, conn.status, "Something went wrong")
  # end
end
