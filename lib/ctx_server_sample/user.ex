defmodule CtxServerSample.User do
  def init do
    :ets.new(:users, [:named_table, :public])
  end

  def login_with_password(user_id, password) do
    require IEx
    IEx.pry
    case :ets.lookup(:users, user_id) do
      [] -> false
      {user_id, hashed_password} -> hashed_password == hash(password)
    end
  end

  def register_with_password(user_id, password) do
    case :ets.lookup(:users, user_id) do
      [] -> :ets.insert(:users, {user_id, hash(password)})
      _ -> false
    end
  end

  defp hash(password) do
    :crypto.hash(:sha, password)
  end
end
