defmodule Rodeo.Meets do
  @moduledoc """
  The Meets context.
  """

  import Ecto.Query, warn: false
  alias Rodeo.Repo

  alias Rodeo.Meets.Meet
  alias Rodeo.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any meet changes.

  The broadcasted messages match the pattern:

    * {:created, %Meet{}}
    * {:updated, %Meet{}}
    * {:deleted, %Meet{}}

  """
  def subscribe_meets(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Rodeo.PubSub, "user:#{key}:meets")
  end

  defp broadcast_meet(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Rodeo.PubSub, "user:#{key}:meets", message)
  end

  @doc """
  Returns the list of meets.

  ## Examples

      iex> list_meets(scope)
      [%Meet{}, ...]

  """
  def list_meets(%Scope{} = scope) do
    Repo.all_by(Meet, user_id: scope.user.id)
  end

  @doc """
  Gets a single meet.

  Raises `Ecto.NoResultsError` if the Meet does not exist.

  ## Examples

      iex> get_meet!(scope, 123)
      %Meet{}

      iex> get_meet!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_meet!(%Scope{} = scope, id) do
    Repo.get_by!(Meet, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a meet.

  ## Examples

      iex> create_meet(scope, %{field: value})
      {:ok, %Meet{}}

      iex> create_meet(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meet(%Scope{} = scope, attrs) do
    with {:ok, meet = %Meet{}} <-
           %Meet{}
           |> Meet.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_meet(scope, {:created, meet})
      {:ok, meet}
    end
  end

  @doc """
  Updates a meet.

  ## Examples

      iex> update_meet(scope, meet, %{field: new_value})
      {:ok, %Meet{}}

      iex> update_meet(scope, meet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meet(%Scope{} = scope, %Meet{} = meet, attrs) do
    true = meet.user_id == scope.user.id

    with {:ok, meet = %Meet{}} <-
           meet
           |> Meet.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_meet(scope, {:updated, meet})
      {:ok, meet}
    end
  end

  @doc """
  Deletes a meet.

  ## Examples

      iex> delete_meet(scope, meet)
      {:ok, %Meet{}}

      iex> delete_meet(scope, meet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meet(%Scope{} = scope, %Meet{} = meet) do
    true = meet.user_id == scope.user.id

    with {:ok, meet = %Meet{}} <-
           Repo.delete(meet) do
      broadcast_meet(scope, {:deleted, meet})
      {:ok, meet}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meet changes.

  ## Examples

      iex> change_meet(scope, meet)
      %Ecto.Changeset{data: %Meet{}}

  """
  def change_meet(%Scope{} = scope, %Meet{} = meet, attrs \\ %{}) do
    true = meet.user_id == scope.user.id

    Meet.changeset(meet, attrs, scope)
  end
end
