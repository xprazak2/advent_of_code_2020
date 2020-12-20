defmodule AdventOfCode.Day04 do
  def part1(args) do
    items = args |> String.split("\n\n")

    fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

    items |> Enum.reduce(0, fn passport, memo -> count_valid(passport, fields, memo) end)
  end

  def count_valid(passport, fields, result) do
    result = if valid?(passport, fields), do: result + 1, else: result

    result
  end

   def valid?(item, fields) do
    fields |> Enum.all?(fn field -> has_field?(item, field) end)
  end

  def has_field?(item, field) do
    ~r/#{field}:(?<cap>\)/ |> Regex.match?(item)
  end

  def part2(args) do
    items = args |> String.split("\n\n") |> Enum.filter(fn str -> str != "" end)
    items |> Enum.reduce(0, &count_strict_valid/2)
  end

  def validator_hash do
    %{
      "byr" => fn value -> 1920 <= String.to_integer(value) && String.to_integer(value) <= 2002 end,
      "iyr" => fn value -> 2010 <= String.to_integer(value) && String.to_integer(value) <= 2020 end,
      "eyr" => fn value -> 2020 <= String.to_integer(value) && String.to_integer(value) <= 2030 end,
      "hgt" => fn value ->
        cond do
          String.ends_with?(value, "cm") -> 150 <= String.to_integer(Regex.run(~r/\d+/, value) |> List.first) && String.to_integer(Regex.run(~r/\d+/, value) |> List.first) <= 193
          String.ends_with?(value, "in") -> 59 <= String.to_integer(Regex.run(~r/\d+/, value) |> List.first) && String.to_integer(Regex.run(~r/\d+/, value) |> List.first) <= 76
          true -> false
        end
      end,
      "hcl" => fn value ->
        !(~r/#[[:alnum:]]{6}$/ |> Regex.run(value) |> is_nil)
      end,
      "ecl" => fn value ->
        !(~r/^(amb|blu|brn|gry|grn|hzl|oth)$/ |> Regex.run(value) |> is_nil)
      end,
      "pid" => fn value ->
        !(~r/^\d{9}$/ |> Regex.run(value) |> is_nil)
      end,
      "cid" => fn value -> true end
    }
  end

  def count_strict_valid(passport, memo) do
    res = debug_valid(passport)
    memo = if res, do: memo + 1, else: memo
    memo
  end

  def debug_valid(passport) do
    segments = String.split(passport, ~r/\s/) |> Enum.filter(fn str -> str != "" end)

    required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

    has_all_required_fields = required_fields |> Enum.all?(fn field -> has_required_field?(passport, field) end)
    if has_all_required_fields do
      segments |> Enum.map(&process_segment/1) |> Enum.all?
    else
      false
    end
  end

  def has_required_field?(passport, field) do
    Regex.run ~r/#{field}:/, passport
  end

  def process_segment(segment) do
    [field, value] = segment |> String.split(":")
    validators = validator_hash()

    validator = Map.get(validators, field)
    validator.(value)
  end
end
