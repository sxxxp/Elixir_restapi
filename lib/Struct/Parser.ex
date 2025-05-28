import Struct.Chat

defmodule Struct.Parser do
  def messageToStruct(message) do
    struct = Jason.decode!(message, keys: :atoms!)
    user_map = Jason.decode!(struct.user, keys: :atoms)
    struct = Map.put(struct, :user, user_map)

    migrate(struct)
  end
end
