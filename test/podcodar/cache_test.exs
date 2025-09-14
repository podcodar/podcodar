defmodule Podcodar.CacheTest do
  use ExUnit.Case, async: false

  alias Podcodar.Cache

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
    # TTL is 1 second
    assert :ok == Cache.put(:key, "value", 1)
    assert {:ok, "value"} == Cache.get(:key)
    # Sleep for a bit more than 1 second
    :timer.sleep(1100)
    assert :error == Cache.get(:key)
  end

  @tag :delete
  test "removes a key from the cache" do
    Cache.put(:key, "value")
    assert {:ok, "value"} == Cache.get(:key)
    assert :ok == Cache.delete(:key)
    assert :error == Cache.get(:key)
  end

  @tag :cache
  test "caches a value using a function" do
    fun = fn -> "computed_value" end

    # First call computes and caches the value
    assert {:ok, "computed_value"} == Cache.cache(:computed_key, fun)

    # Second call retrieves the cached value
    assert {:ok, "computed_value"} == Cache.get(:computed_key)
  end

  @tag :concurrent
  test "handles concurrent cache access" do
    fun = fn -> "concurrent_value" end

    # Spawn multiple processes accessing the cache concurrently
    tasks =
      for _ <- 1..10 do
        Task.async(fn -> Cache.cache(:concurrent_key, fun) end)
      end

    # Ensure all processes return the same cached value
    assert Enum.all?(Task.await_many(tasks), &(&1 == {:ok, "concurrent_value"}))
  end

  @tag :invalid_key
  test "returns an error when accessing an invalid key" do
    assert :error == Cache.get(:nonexistent_key)
  end
end
