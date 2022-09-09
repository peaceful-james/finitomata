defmodule Finitomata.Test.Plant do
  @moduledoc false

  @fsm """
  [*] --> s1 : to_s1
  s1 --> s2 : to_s2
  s1 --> s3 : to_s3
  s2 --> [*] : ok
  s3 --> [*] : ok
  """

  use Finitomata, {@fsm, Finitomata.PlantUML}

  @impl Finitomata
  def on_transition(:s1, :to_s2, event_payload, state_payload) do
    Logger.info(
      "[✓ ⇄] with: " <>
        inspect(
          event_payload: event_payload,
          state: state_payload
        )
    )

    {:ok, :s2, state_payload}
  end
end

defmodule Finitomata.Test.Log do
  @moduledoc false

  @fsm """
  idle --> |accept| accepted
  idle --> |reject| rejected
  """

  use Finitomata, fsm: @fsm, syntax: Finitomata.Mermaid, impl_for: :all
end

defmodule Finitomata.Test.Callback do
  @moduledoc false

  @fsm """
  idle --> |process| processed
  """

  use Finitomata, fsm: @fsm

  @impl Finitomata
  def on_transition(:idle, :process, %{pid: pid}, state_payload) do
    send(pid, :on_transition)

    {:ok, :processed, Map.put(state_payload, :pid, pid)}
  end
end
