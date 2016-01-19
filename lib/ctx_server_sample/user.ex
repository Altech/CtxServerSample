defmodule CtxServerSample.User do
  use Ecto.Schema

  alias CtxServerSample.Repo

  schema "users" do
    field :screen_name, :string
    field :password_digest, :binary
  end

  def create(screen_name, password) do
    if alreadly_exists?(screen_name) do
      false
    else
      user = %__MODULE__{screen_name: screen_name, password_digest: digest(password)}
      Repo.insert(user)
    end
  end

  def check_password(screen_name, password) do
    user = find_by_screen_name(screen_name)
    if user do
      user.password_digest == digest(password)
    else
      false
    end
  end

  defp alreadly_exists?(screen_name) do
    !!find_by_screen_name(screen_name)
  end

  def find_by_screen_name(screen_name) do
    import Ecto.Query, only: [from: 2]
    Repo.one(from u in __MODULE__, where: u.screen_name == ^screen_name)
  end

  def find_by_id(id) do
    Repo.get __MODULE__, id
  end

  defp digest(password) do
    :crypto.hash(:sha, password)
  end
end
