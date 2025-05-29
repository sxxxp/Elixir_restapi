defmodule ChatLogger do
  def log(room_id, %Struct.Chat{} = msg) do
    File.write(
      "#{System.get_env("CHAT_LOG_DIR", "logs/chat_logs/")}#{room_id}.log",
      "#{Struct.Chat.get_to_string(msg)}\n",
      [:append]
    )
  end

  def log(room_id, message) do
    File.write(
      "#{System.get_env("CHAT_LOG_DIR", "logs/chat_logs/")}#{room_id}.log",
      "#{message}\n",
      [:append]
    )
  end

  def read(room_id) do
    file_path = "#{System.get_env("CHAT_LOG_DIR", "logs/chat_logs/")}#{room_id}.log"

    case File.read(file_path) do
      {:ok, content} ->
        content

      {:error, reason} ->
        ErrorLogger.elog("ChatLogger", "Error reading log file: #{reason}")
        ""
    end
  end

  def readLast(room_id) do
    file_path = "#{System.get_env("CHAT_LOG_DIR", "logs/chat_logs/")}#{room_id}.log"

    case File.read(file_path) do
      {:ok, content} ->
        content |> String.split("\n", trim: true) |> List.last()

      {:error, reason} ->
        ErrorLogger.elog("ChatLogger", "Error reading log file: #{reason}")
        ""
    end
  end

  def to_jason(%Struct.Chat{} = msg) do
    Jason.encode!(msg)
  end
end
