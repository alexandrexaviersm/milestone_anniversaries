defmodule MilestoneAnniversaries.CLI do
  @moduledoc """

  """

  import MilestoneAnniversaries.Validations

  def main(_args) do
    file_path = read_file_path_from_user_input()
    run_date = read_run_date_from_user_input()

    with :ok <- validate_extension(file_path),
         :ok <- validate_exists(file_path),
         {:ok, erl_date} <- parse_date_to_erl_format(run_date),
         {:ok, formatted_run_date} <- validate_and_converts_erl_date(erl_date) do
      csv_data = File.stream!(file_path)

      csv_data
      |> Stream.map(&String.trim(&1))
      |> Stream.map(&String.split(&1, ","))
      |> Stream.filter(fn
        ["employee_id" | _] ->
          false

        [_, _, _, hire_date | _] ->
          {:ok, hire_date} = Date.from_iso8601(hire_date)

          with true <- rem(formatted_run_date.year, 5) == rem(hire_date.year, 5),
               true <- formatted_run_date.year >= hire_date.year + 5,
               true <- hire_date.month >= formatted_run_date.month,
               true <- hire_date.day >= formatted_run_date.day do
            true
          end
      end)
      |> Enum.group_by(fn [_, _, _, _, supervisor_id] -> supervisor_id end)
      |> Enum.map(fn {supervisor_id, value} ->
        upcoming_milestones =
          Stream.map(value, fn [employee_id, _, _, hire_date, _] ->
            {:ok, a} = Date.from_iso8601(hire_date)
            {:ok, anniversary_date} = Date.new(formatted_run_date.year, a.month, a.day)
            %{employee_id: employee_id, anniversary_date: anniversary_date}
          end)
          |> Stream.take(5)
          |> Enum.sort_by(& &1.anniversary_date, Date)

        %{supervisor_id: supervisor_id, upcoming_milestones: upcoming_milestones}
      end)
      |> IO.inspect()
    end
  end

  defp read_file_path_from_user_input do
    "Enter the csv file name: "
    |> IO.gets()
    |> String.trim()
  end

  defp read_run_date_from_user_input do
    "Enter the run date: (use the format mm/dd/yyyy): "
    |> IO.gets()
    |> String.trim()
  end
end
