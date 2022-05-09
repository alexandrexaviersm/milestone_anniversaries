defmodule MilestoneAnniversariesTest do
  use ExUnit.Case

  @csv_file_path "employee_data.csv"
  @run_date "12/01/1985"

  describe "MilestoneAnniversaries.direct_report/2" do
    test "should return :ok after processing a valid csv file" do
      assert MilestoneAnniversaries.direct_report(@csv_file_path, @run_date) == :ok
    end

    test "should return an error tuple after trying to process an invalid csv file" do
      assert MilestoneAnniversaries.direct_report("invalid_file", @run_date) ==
               {:error, :error_processing_csv_file}
    end

    test "should return an error tuple after trying to process with an invalid run date" do
      assert MilestoneAnniversaries.direct_report(@csv_file_path, "invalid_run_date") ==
               {:error, :error_processing_csv_file}
    end
  end
end
