defmodule MilestoneAnniversaries.ValidationsTest do
  use ExUnit.Case

  alias MilestoneAnniversaries.Validations

  describe "Validations.parse_and_validate_string_date_to_erl_format/1" do
    test "should parse a valid date in the format mm/dd/yyyy" do
      assert Validations.parse_and_validate_string_date_to_erl_format("04/1/2000") ==
               {:ok, {2000, 4, 1}}
    end

    test "should return an error tuple for invalid date formats" do
      for invalid_date <- ["", "string", "april/01/2000", "April, 01, 2000"] do
        assert Validations.parse_and_validate_string_date_to_erl_format(invalid_date) ==
                 {:error, :invalid_date}
      end
    end
  end

  describe "Validations.convert_and_validate_erl_date_to_date_format/1" do
    test "should return an ok typle with a valid erl date" do
      assert Validations.convert_and_validate_erl_date_to_date_format({2000, 4, 1}) ==
               {:ok, ~D[2000-04-01]}
    end

    test "should return an error tuple for invalid erl date" do
      for invalid_date <- [
            {2000, 2, 30},
            {2000, -04, 01},
            {2000, 13, 01},
            {2000, 4, 32},
            "",
            [2000, 4, 1]
          ] do
        assert Validations.convert_and_validate_erl_date_to_date_format(invalid_date) ==
                 {:error, :invalid_date}
      end
    end
  end
end
