defmodule AdventOfCode.Day01 do
  def part1(input) do
    input |> load_input |> find_two(2020) |> multiply
  end

  def find_two([], _total) do
    []
  end

  def find_two(list, _total) when length(list) == 1 do
    []
  end

  def find_two(list, total) do
    [head | tail] = list
    found = tail |> Enum.find(fn item -> item + head == total end)
    if found do
      [head, found]
    else
      find_two tail, total
    end
  end

  def multiply([]) do
    0
  end

  def multiply(list) do
    list |> Enum.reduce(fn item, memo -> memo * item end)
  end

  def load_input(input) do
    input |> String.split |> Enum.map(&String.to_integer/1)
  end

  def find_three([]) do
    []
  end

  def find_three(list) do
    [head | tail] = list
    two = find_two(tail, 2020 - head)
    if Enum.empty?(two) do
      find_three tail
    else
      [head | two]
    end
  end

  def part2(input) do
    input |> load_input |> find_three |> multiply
  end
end
