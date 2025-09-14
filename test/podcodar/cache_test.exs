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
end
