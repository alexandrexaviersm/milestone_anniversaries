defmodule MilestoneAnniversaries.ReportTest do
  use ExUnit.Case

  alias MilestoneAnniversaries.Report

  @csv_file_path "test/support/test_employee_data.csv"

  describe "MilestoneAnniversaries.Report.direct_report/2" do
    test "should return a valid direct_report" do
      run_date = "12/01/1985"

      assert Report.direct_report(@csv_file_path, run_date) ==
               {:ok,
                [
                  %{
                    supervisor_id: "ballison200",
                    upcoming_milestones: [
                      %{
                        anniversary_date: ~D[1985-12-11],
                        employee_id: "apowers212"
                      }
                    ]
                  },
                  %{
                    supervisor_id: "lconrad254",
                    upcoming_milestones: [
                      %{
                        anniversary_date: ~D[1985-12-16],
                        employee_id: "ljackson264"
                      }
                    ]
                  }
                ]}
    end

    test "should return max 5 upcoming_milestones for each supervisor" do
      run_date = "05/01/2022"

      {:ok, direct_report} = Report.direct_report(@csv_file_path, run_date)

      %{supervisor_id: "test_sup_123id", upcoming_milestones: upcoming_milestones} =
        Enum.find(direct_report, fn %{supervisor_id: supervisor_id} ->
          supervisor_id == "test_sup_123id"
        end)

      assert length(upcoming_milestones) == 5
    end

    test "should return the next 5 upcoming_milestones in order" do
      run_date = "05/01/2022"

      {:ok, direct_report} = Report.direct_report(@csv_file_path, run_date)

      %{supervisor_id: "test_sup_123id", upcoming_milestones: upcoming_milestones} =
        Enum.find(direct_report, fn %{supervisor_id: supervisor_id} ->
          supervisor_id == "test_sup_123id"
        end)

      assert upcoming_milestones == [
               %{anniversary_date: ~D[2022-05-01], employee_id: "test_employee_id_1"},
               %{anniversary_date: ~D[2022-06-02], employee_id: "test_employee_id_2"},
               %{anniversary_date: ~D[2022-07-03], employee_id: "test_employee_id_3"},
               %{anniversary_date: ~D[2022-08-04], employee_id: "test_employee_id_4"},
               %{anniversary_date: ~D[2022-09-05], employee_id: "test_employee_id_5"}
             ]
    end
  end
end
