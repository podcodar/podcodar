defmodule Podcodar.CacheTest do
  use ExUnit.Case, async: false

  alias Podcodar.Cache

  setup do
    # Start the Cache GenServer before each test
    {:ok, _pid} = Cache.start_link([])
    :ok
  end

  @tag :get
  test "retrieves a value from the cache" do
    Cache.put(:key, "value")
    assert {:ok, "value"} == Cache.get(:key)
  end

  @tag :put
  test "stores a value in the cache" do
    assert :ok == Cache.put(:key, "value")
    assert {:ok, "value"} == Cache.get(:key)
  end

  @tag :put_ttl
  test "stores a value in the cache with TTL and verifies expiration" do
    assert :ok == Cache.put(:key, "value", 1) # TTL is 1 second
    assert {:ok, "value"} == Cache.get(:key)
    :timer.sleep(1100) # Sleep for a bit more than 1 second
    assert :error == Cache.get(:key)
  end

  @tag :delete
  test "removes a key from the cache" do
    Cache.put(:key, "value")
    assert {:ok, "value"} == Cache.get(:key)
    assert :ok == Cache.delete(:key)
    assert :error == Cache.get(:key)
  end
end
