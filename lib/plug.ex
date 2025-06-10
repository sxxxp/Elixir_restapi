defmodule MyPlug do
  def init(options) do
    # initialize options
    options
  end

  def call(conn, _opts) do
    conn
  end

  def database do
    quote do
      alias MyApp.Repo, as: PG
      alias Schema.User, as: User
      alias Schema.Item, as: Item

      def on_error(message) do
        ErrorLogger.elog(__MODULE__, message)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
