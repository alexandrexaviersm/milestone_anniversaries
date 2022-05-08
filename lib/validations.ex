defmodule MilestoneAnniversaries.Validations do
  @moduledoc """

  """

  @spec validate_extension(binary) :: :ok | {:error, :invalid_extension}
  def validate_extension(path) do
    if Path.extname(path) == ".csv", do: :ok, else: {:error, :invalid_extension}
  end

  @spec validate_exists(binary) :: :ok | {:error, :missing_file}
  def validate_exists(path) do
    if File.exists?(path), do: :ok, else: {:error, :missing_file}
  end

  @spec parse_date_to_erl_format(binary) ::
          {:ok, {integer, integer, integer}} | {:error, :invalid_date}

  def parse_date_to_erl_format(date) do
    with [month, day, year] <- String.split(date, "/"),
         {month, _} <- Integer.parse(month),
         {day, _} <- Integer.parse(day),
         {year, _} <- Integer.parse(year) do
      {:ok, {year, month, day}}
    else
      _ -> {:error, :invalid_date}
    end
  end

  @spec validate_and_converts_erl_date(tuple) :: {:ok, Date.t()} | {:invalid_date}
  def validate_and_converts_erl_date(date) when is_tuple(date) do
    case Date.from_erl(date) do
      {:ok, date} -> {:ok, date}
      _ -> {:error, :invalid_date}
    end
  end

  def validate_and_converts_erl_date(_date), do: {:error, :invalid_date}
end
