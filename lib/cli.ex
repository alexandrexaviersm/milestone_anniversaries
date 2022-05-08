defmodule MilestoneAnniversaries.CLI do
  @moduledoc """

  """

  import MilestoneAnniversaries.Validations

  def main(_args) do
    IO.puts("Hello from MilestoneAnniversaries!")

    file_path = IO.gets("Enter the csv file name: \n") |> String.trim()
    date = IO.gets("Enter the run date: (use the format mm/dd/yyyy) \n") |> String.trim()

    with :ok <- validate_extension(file_path),
         :ok <- validate_exists(file_path),
         {:ok, _data} <- File.read(file_path),
         {:ok, erl_date} <- parse_date_to_erl_format(date),
         {:ok, _date} <- validate_and_converts_erl_date(erl_date) do
      :ok
    end
  end
end
