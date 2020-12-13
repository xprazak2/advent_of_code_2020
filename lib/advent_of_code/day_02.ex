defmodule AdventOfCode.Day02 do
  def part1(args) do
    args |> load_to_map |> count_valid(&validate_entry/2)
  end

  def count_valid(maps, validator) do
    maps |> Enum.reduce(0, validator)
  end

  def validate_entry(entry, result) do
    graphemes = entry["password"] |> String.graphemes
    count = graphemes |> Enum.count(fn char -> char == entry["letter"] end)

    if String.to_integer(entry["min"]) <= count && count <= String.to_integer(entry["max"]) do
      result + 1
    else
      result
    end
  end

  def validate_entry_again(entry, result) do
    graphemes = entry["password"] |> String.graphemes
    min = entry["min"] |> String.to_integer
    max = entry["max"] |> String.to_integer

    first = graphemes |> Enum.at(min - 1)
    second = graphemes |> Enum.at(max - 1)
    letter = entry["letter"]

    if (first == letter && second == letter) || (first != letter && second != letter) do
      result
    else
      result + 1
    end
  end

  def to_map(line) do
    regex = ~r/^(?<min>\d+)-(?<max>\d+)\s(?<letter>\w):\s(?<password>\w+)$/
    Regex.named_captures regex, line
  end

  def load_to_map(args) do
    args |> String.split("\n") |> Enum.filter(fn str -> str != "" end) |> Enum.map(&to_map/1)
  end

  def part2(args) do
    args |> load_to_map |> count_valid(&validate_entry_again/2)
  end
end
