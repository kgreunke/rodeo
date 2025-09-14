defmodule Rodeo.MeetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rodeo.Meets` context.
  """

  @doc """
  Generate a meet.
  """
  def meet_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        date: ~N[2025-09-13 03:41:00],
        location: "some location",
        name: "some name"
      })

    {:ok, meet} = Rodeo.Meets.create_meet(scope, attrs)
    meet
  end
end
