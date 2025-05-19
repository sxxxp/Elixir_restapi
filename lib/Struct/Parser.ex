import Struct.Chat

defmodule Struct.Parser do
  def messageToStruct(message) do
    struct = Jason.decode!(message, keys: :atoms!)
    IO.inspect(struct)
    migrate(struct)
  end
end
