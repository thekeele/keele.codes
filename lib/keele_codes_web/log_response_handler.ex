defmodule KeeleCodesWeb.LogResponseHandler do
  require Logger

  def handle_event(
        [:keele_codes, :dojo_live, :connection] = event,
        measurements,
        _metadata,
        _config
      ) do
    Logger.info("[#{inspect(__MODULE__)}] #{inspect(event)} #{inspect(measurements)}")
  end

  def handle_event(
        [:keele_codes, :dojo_live, :link_clicked] = event,
        measurements,
        _metadata,
        _config
      ) do
    Logger.info("[#{inspect(__MODULE__)}] #{inspect(event)} #{inspect(measurements)}")
  end

  def handle_event(_event, _measurements, _metadata, _config), do: :ok
end
