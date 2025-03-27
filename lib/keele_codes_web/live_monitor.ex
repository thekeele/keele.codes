defmodule KeeleCodesWeb.LiveMonitor do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def monitor(pid, meta) do
    GenServer.call(__MODULE__, {:monitor, pid, meta})
  end

  def init(_) do
    :ok =
      :telemetry.attach_many(
        "log-response-handler",
        [
          [:keele_codes, :dojo_live, :connection],
          [:keele_codes, :dojo_live, :link_clicked]
        ],
        &KeeleCodesWeb.LogResponseHandler.handle_event/4,
        nil
      )

    {:ok, %{}}
  end

  def handle_call({:monitor, pid, meta}, _from, state) do
    Process.monitor(pid)

    {:reply, :ok, Map.put(state, pid, meta)}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    meta = state[pid]

    duration = System.monotonic_time() - meta.mount_time
    duration_sec = System.convert_time_unit(duration, :native, :millisecond) / 1_000

    :telemetry.execute(
      [:keele_codes, :dojo_live, :connection],
      %{duration: duration_sec},
      meta
    )

    {:noreply, Map.delete(state, pid)}
  end
end
