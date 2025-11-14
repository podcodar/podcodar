defmodule Podcodar.Accounts.ScopeTest do
  use Podcodar.DataCase

  alias Podcodar.Accounts
  alias Podcodar.Accounts.Scope

  import Podcodar.AccountsFixtures

  describe "for_user/1" do
    test "creates a scope for a user" do
      user = user_fixture()
      scope = Scope.for_user(user)
      assert %Scope{user: ^user} = scope
    end

    test "returns nil for nil user" do
      assert Scope.for_user(nil) == nil
    end
  end

  describe "has_role?/2" do
    test "returns true when scope user has the specified role" do
      user = user_fixture()
      scope = Scope.for_user(user)
      assert Scope.has_role?(scope, "member")
      refute Scope.has_role?(scope, "admin")
    end

    test "returns false for nil scope" do
      refute Scope.has_role?(nil, "admin")
    end

    test "returns false for scope without user" do
      scope = %Scope{user: nil}
      refute Scope.has_role?(scope, "admin")
    end
  end

  describe "admin?/1" do
    test "returns true for admin scope" do
      user = user_fixture()
      {:ok, admin_user} = Accounts.update_user_role(user, "admin")
      scope = Scope.for_user(admin_user)
      assert Scope.admin?(scope)
    end

    test "returns false for non-admin scope" do
      user = user_fixture()
      scope = Scope.for_user(user)
      refute Scope.admin?(scope)
    end

    test "returns false for nil scope" do
      refute Scope.admin?(nil)
    end
  end

  describe "interviewer?/1" do
    test "returns true for interviewer scope" do
      user = user_fixture()
      {:ok, interviewer_user} = Accounts.update_user_role(user, "interviewer")
      scope = Scope.for_user(interviewer_user)
      assert Scope.interviewer?(scope)
    end

    test "returns true for admin scope" do
      user = user_fixture()
      {:ok, admin_user} = Accounts.update_user_role(user, "admin")
      scope = Scope.for_user(admin_user)
      assert Scope.interviewer?(scope)
    end

    test "returns false for member scope" do
      user = user_fixture()
      scope = Scope.for_user(user)
      refute Scope.interviewer?(scope)
    end

    test "returns false for nil scope" do
      refute Scope.interviewer?(nil)
    end
  end

  describe "has_any_role?/2" do
    test "returns true when scope user has one of the specified roles" do
      user = user_fixture()
      scope = Scope.for_user(user)
      assert Scope.has_any_role?(scope, ["member", "admin"])
      refute Scope.has_any_role?(scope, ["admin", "interviewer"])
    end

    test "returns false for nil scope" do
      refute Scope.has_any_role?(nil, ["admin"])
    end
  end
end
