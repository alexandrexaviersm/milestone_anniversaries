# MilestoneAnniversaries

**Programming Assessment**

## Installation

If you already have Erlang version 24 installed, you can run the program by running the executable script `./milestone_anniversaries`

If not, one way to install it is by running `asdf install` to install the correct version of Erlang and Elixir (if you use `asdf` as a package manager)

After that, run `mix deps.get`


## Running

You can run the program in 2 ways:
  - By running the executable script `./milestone_anniversaries`
  - By running with `iex -S mix`
      - while on `iex`, you can run the function `MilestoneAnniversaries.direct_report/2`  
      ```elixir
      iex> MilestoneAnniversaries.direct_report("employee_data.csv", "10/01/2015")
      ```
      This function accepts 2 arguments. The path to a csv file and a date in mm/dd/yyyy format


