defmodule ErrorLogger do
  def elog("", _message) do
    elog("ErrorLogger", "Module name cannot be empty")
    {:error, "Module name cannot be empty"}
  end

  def elog(module, message) do
    time =
      MyTime.now()
      |> MyTime.get_to_string()

    File.write(
      "error_log/#{module}.log",
      MyUtil.keyword_to_json(message: message, time: time) <> "\n",
      [:append]
    )
  end

  def eread(module) do
    file_path = "error_log/#{module}.log"

    case File.read(file_path) do
      {:ok, content} ->
        content

      {:error, reason} ->
        elog("ErrorLogger", "Error reading log file: #{reason}")
        ""
    end
  end

  def eread_recently(module) do
    file_path = "error_log/#{module}.log"

    case File.read(file_path) do
      {:ok, content} ->
        content |> String.split("\n", trim: true) |> List.last()

      {:error, reason} ->
        elog("ErrorLogger", "Error reading log file: #{reason}")
        ""
    end
  end

  def to_jason(%Struct.Chat{} = msg) do
    Jason.encode!(msg)
  end
end
