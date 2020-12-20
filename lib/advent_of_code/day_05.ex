defmodule AdventOfCode.Day05 do
  def part1(args) do
    input = args |> String.split("\n") |> Enum.filter(fn val -> val != "" end)
    pass_a = "FBFBBFFRLR"
    pass_b = "BFFFBBFRRR"
    pass_c = "FFFBBBFRRR"

    input |> Enum.map(&process_pass/1) |> Enum.max
  end

  def process_pass(boarding_pass) do
    col_string = boarding_pass |> String.slice(-3..-1)
    row_string = boarding_pass |> String.slice(0..6)

    row_result = binsearch(row_string, "B", "F")
    col_result = binsearch(col_string, "R", "L")
    row_result * 8 + col_result
  end

  def binsearch(string, upper_sym, lower_sym) do
    sequence = string |> String.codepoints
    exp = sequence |> Enum.count
    size = :math.pow(2, exp)
    final_bounds = sequence |> Enum.reduce(%{:upper => size, :lower => 0}, fn item, memo -> slice_input(item, memo, upper_sym, lower_sym) end)

    final_bounds.upper - 1
  end

  def slice_input(char, bounds, upper_sym, lower_sym) do
    move_by = (bounds.upper - bounds.lower) / 2
    case char do
      ^upper_sym -> %{ :upper => bounds.upper, :lower => bounds.lower + move_by }
      ^lower_sym -> %{ :upper => bounds.upper - move_by, :lower => bounds.lower }
      _ -> raise "Unexpected symbol: #{char}"
    end
  end

  def part2(args) do
    input = args |> String.split("\n") |> Enum.filter(fn val -> val != "" end)
    ids = input |> Enum.map(&process_pass/1) |> Enum.sort
    find_next(ids) + 1
  end

  def find_next(ids) do
    [first | rest] = ids
    if Float.round(first) + 1 == Float.round(List.first(rest)) do
      rest |> find_next
    else
      first
    end
  end
end
