defmodule MilestoneAnniversaries do
  @moduledoc """
  Documentation for `MilestoneAnniversaries`.
  """

  alias MilestoneAnniversaries.Report

  @doc """
  Direct report.

  ## Examples

      iex> MilestoneAnniversaries.direct_report("employee_data.csv", "10/01/2015")
      [
        {
          "supervisor_id": "jbrady157",
          "upcoming_milestones": [
            {
              "anniversary_date": "2015-02-27",
              "employee_id": "npoole175"
            },
            {
              "anniversary_date": "2015-04-18",
              "employee_id": "ghooper161"
            },
            {
              "anniversary_date": "2015-05-03",
              "employee_id": "jburt169"
            }
          ]
        }
      ]
  """
  defdelegate direct_report(file_path, run_date), to: Report, as: :print_direct_report_in_json
end
