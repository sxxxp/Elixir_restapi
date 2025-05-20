defmodule MyUtil do
  def extract_params(params, keys) do
    Enum.map(keys, &Map.get(params, &1))
  end

  def keyword_to_json(keyword_list) when is_list(keyword_list) do
    keyword_list
    |> Enum.into(%{})
    |> Jason.encode!()
  end
end
