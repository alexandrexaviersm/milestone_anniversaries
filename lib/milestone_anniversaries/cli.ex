defmodule MilestoneAnniversaries.CLI do
  @moduledoc """
  Documentation for `MilestoneAnniversaries.CLI`.
  """

  def main(_args) do
    file_path = read_user_input("Enter the csv file name: ")
    run_date = read_user_input("Enter the run date: (use the format mm/dd/yyyy): ")

    MilestoneAnniversaries.direct_report(file_path, run_date)
  end

  defp read_user_input(msg) do
    msg
    |> IO.gets()
    |> String.trim()
  end
end
