defmodule Podcodar.Cache do
  use GenServer
  require Logger

  @cache_table :podcodar_cache

  defmodule State do
    defstruct [:table]
  end

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  ## Server functions

  @impl true
  def init(state) do
    :ets.new(@cache_table, [:set, :public, :named_table])

    {:ok, state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    value =
      case :ets.lookup(@cache_table, key) do
        [{^key, value}] -> {:ok, value}
        [] -> :error
      end

    {:reply, value, state}
  end

  @impl true
  def handle_cast({:put, key, value, ttl}, state) when is_number(ttl) do
    :ets.insert(@cache_table, {key, value})

    if ttl > 0 do
      Process.send_after(self(), {:expire, key}, ttl * 1000)
    end

    {:noreply, state}
  end

  @impl true
  def handle_cast({:expire, key}, state) do
    # call handle_info to centralize the logic
    handle_info({:expire, key}, state)
    {:noreply, state}
  end

  @impl true
  def handle_info({:expire, key}, state) do
    Logger.debug("Cache expired for key: #{inspect(key)}")

    :ets.delete(@cache_table, key)

    {:noreply, state}
  end

  ## Client functions

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value, 0})
  end

  def put(key, value, ttl) when is_number(ttl) do
    GenServer.cast(__MODULE__, {:put, key, value, ttl})
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:expire, key})
  end

  def cache(key, fun, ttl \\ 3600) when is_function(fun, 0) do
    case get(key) do
      {:ok, value} ->
        {:ok, value}

      :error ->
        value = fun.()
        put(key, value, ttl)
        {:ok, value}
    end
  end
end
