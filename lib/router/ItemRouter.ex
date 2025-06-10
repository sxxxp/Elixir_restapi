defmodule MyRouter.ItemRouter do
  use Router, :router
  use MyPlug, :database

  get "/:code" do
    item = PG.get_by(Item, code: code)

    case item do
      %Item{} ->
        send_resp(
          conn,
          200,
          Jason.encode!(%{
            name: item.name,
            description: item.description,
            tradeable: item.tradeable,
            price: item.price,
            image: item.image
          })
        )

      nil ->
        send_resp(conn, 404, "Item not found")
    end
  end

  match _ do
    send_resp(conn, 404, "You should send a message")
  end
end
