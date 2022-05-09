defmodule MilestoneAnniversaries.Report do
  @moduledoc """
  Documentation for `MilestoneAnniversaries.Report`.
  """
  import MilestoneAnniversaries.Validations

  @spec print_direct_report_in_json(binary, binary) :: :ok | {:error, :error_processing_csv_file}
  def print_direct_report_in_json(file_path, run_date) do
    with {:ok, direct_report} <- direct_report(file_path, run_date),
         {:ok, json_report} <- Jason.encode(direct_report, pretty: true) do
      IO.puts(json_report)
    else
      _ -> {:error, :error_processing_csv_file}
    end
  end

  @spec direct_report(binary, binary) ::
          {:ok, list} | {:error, :invalid_date | :invalid_extension | :missing_file}
  def direct_report(file_path, run_date) do
    with :ok <- validate_extension(file_path),
         :ok <- validate_exists(file_path),
         {:ok, erl_date} <- parse_and_validate_string_date_to_erl_format(run_date),
         {:ok, formatted_run_date} <- convert_and_validate_erl_date_to_date_format(erl_date) do
      {:ok, process_csv_employee_data(file_path, formatted_run_date)}
    end
  end

  defp process_csv_employee_data(file_path, run_date) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.split(&1, ","))
    |> stream_filter_upcoming_milestones(run_date)
    |> Enum.group_by(fn [_emp_id, _f_name, _l_name, _date, supervisor_id] -> supervisor_id end)
    |> Enum.map(fn {supervisor_id, employees_data} ->
      %{
        supervisor_id: supervisor_id,
        upcoming_milestones: format_valid_upcoming_milestones(employees_data, run_date.year)
      }
    end)
  end

  defp stream_filter_upcoming_milestones(csv_row, run_date) do
    Stream.filter(csv_row, fn
      [_emp_id, _f_name, _l_name, hire_date, _sup_id] ->
        with {:ok, hire_date} <- parse_iso8601_date(hire_date),
             true <- rem(run_date.year, 5) == rem(hire_date.year, 5),
             true <- run_date.year >= hire_date.year + 5,
             true <- hire_date.month >= run_date.month,
             true <- hire_date.day >= run_date.day do
          true
        end

      _ ->
        false
    end)
  end

  defp format_valid_upcoming_milestones(employees_data, anniversary_year) do
    Enum.reduce(employees_data, [], fn [employee_id, _f_name, _l_name, hire_date, _sup_id], acc ->
      with {:ok, a} <- parse_iso8601_date(hire_date),
           {:ok, anniversary_date} <- Date.new(anniversary_year, a.month, a.day) do
        [%{employee_id: employee_id, anniversary_date: anniversary_date} | acc]
      else
        _ -> acc
      end
    end)
    |> Enum.reverse()
    |> Enum.take(5)
    |> Enum.sort_by(& &1.anniversary_date, Date)
  end

  defp parse_iso8601_date(iso8601_date) do
    case Date.from_iso8601(iso8601_date) do
      {:ok, date} -> {:ok, date}
      {:error, _} -> false
    end
  end
end
