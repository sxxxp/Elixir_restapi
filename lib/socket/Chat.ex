defmodule Socket.Chat do
  @behaviour WebSock
  import ChatLogger
  import Struct.Parser, only: [messageToStruct: 1]

  def init(options) do
    :pg.join({:chat_room, options[:id]}, self())
    IO.puts("Socket initialized")

    # options = Map.put(options, :pg, :pg.get_members({:chat_room, options[:id]}))
    {:ok, options}
  end

  def handle_in({message, [opcode: :text]}, state) do
    message = messageToStruct(message)
    do_handle(message, state)
  end

  def do_handle(%Struct.Chat{type: "join"} = msg, state) do
    data = read(state[:id]) <> "\n"
    msgStr = Struct.Chat.get_to_string(msg)
    log(state[:id], msg)
    broadcast(:join, msgStr, state)
    {:push, {:text, data <> msgStr}, state}
  end

  def do_handle(%Struct.Chat{type: "send"} = msg, state) do
    log(state[:id], msg)
    msgStr = Struct.Chat.get_to_string(msg)
    broadcast(:send, msgStr, state)
    {:push, {:text, msgStr}, state}
  end

  def do_handle(%Struct.Chat{type: "exit"} = msg, state) do
    log(state[:id], msg)
    msgStr = Struct.Chat.get_to_string(msg)
    broadcast(:exit, msgStr, state)
    {:push, {:text, msgStr}, state}
  end

  def do_handle(_, state) do
    {:push, {:text, "invaild_format"}, state}
  end

  def handle_info(send, _state) do
    send
  end

  def broadcast(:join, msg, state) do
    for pid <- :pg.get_members({:chat_room, state[:id]}), pid != self() do
      send(pid, {:push, {:text, msg}, state})
    end
  end

  def broadcast(:send, msg, state) do
    # for pid <- state[:pg], pid != self() do
    #   send(pid, {:push, {:text, msg}, state})
    # end

    for pid <- :pg.get_members({:chat_room, state[:id]}), pid != self() do
      send(pid, {:push, {:text, msg}, state})
    end
  end

  def broadcast(:exit, msg, state) do
    for pid <- :pg.get_members({:chat_room, state[:id]}), pid != self() do
      send(pid, {:push, {:text, msg}, state})
    end
  end

  def terminate(_, state) do
    IO.puts("Socket terminated")
    :pg.leave({:chat_room, state[:id]}, self())
    :ok
  end
end
