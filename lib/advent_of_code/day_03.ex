defmodule AdventOfCode.Day03 do
  require IEx

  def part1(args) do
    slope = args |> String.split("\n")

    width = slope |> List.first |> String.length
    slope = slope |> Enum.filter(fn line -> String.length(line) == width end)
    slope |> Enum.reduce(%{ trees_count: 0, width: width, position_x: 0 }, &step_down/2)
  end

  def step_down(step, memo) do
    %{ :trees_count => trees_count, :width => width, :position_x => position_x } = memo

    position_x = if position_x >= width, do: rem(position_x, width), else: position_x

    trees_count = if String.at(step, position_x) == "#", do: trees_count + 1, else: trees_count

    %{ :trees_count => trees_count, :width => width, :position_x => position_x + 3 }
  end

  def part2(args) do
    slope = args |> String.split("\n")

    width = slope |> List.first |> String.length
    slope = slope |> Enum.filter(fn line -> String.length(line) == width end)
    height = slope |> length

    one_one = slope |> check_slope(height, width, 0, 0, 1, 1, 0)
    three_one = slope |> check_slope(height, width, 0, 0, 3, 1, 0)
    five_one = slope |> check_slope(height, width, 0, 0, 5, 1, 0)
    seven_one = slope |> check_slope(height, width, 0, 0, 7, 1, 0)
    one_two = slope |> check_slope(height, width, 0, 0, 1, 2, 0)
    [one_one, three_one, five_one, seven_one, one_two, one_one * three_one * five_one * seven_one * one_two]
  end

  def check_slope(slope, height, width, position_x, position_y, step_x, step_y, trees_count) when length(slope) <= position_y do
    trees_count
  end

  def check_slope(slope, height, width, position_x, position_y, step_x, step_y, trees_count) do
    position_x = if position_x >= width, do: rem(position_x, width), else: position_x

    step = Enum.at slope, position_y
    trees_count = if String.at(step, position_x) == "#", do: trees_count + 1, else: trees_count
    check_slope slope, height, width, position_x + step_x, position_y + step_y, step_x, step_y, trees_count
  end
end
