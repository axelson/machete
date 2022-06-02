defmodule ExMatchers.LiteralMatchers do
  @moduledoc """
  This module defines ExMatchers.Matchable protocol conformance for a number of 
  literal types. We use whichever equality semantic is indicated for the type (`match?/2` for
  Regex, `compare/2` for date-like types, `===` for everything else).

  Note that literal collection matching is not handled here; each collection type has their own
  literal matcher module defined separately.
  """

  defimpl ExMatchers.Matchable, for: Regex do
    def mismatches(%Regex{} = a, b) when is_binary(b) do
      if Regex.match?(a, b) do
        []
      else
        [%ExMatchers.Mismatch{message: "Regex does not match"}]
      end
    end

    def mismatches(%Regex{}, _), do: [%ExMatchers.Mismatch{message: "Not a binary"}]
  end

  for t <- [DateTime, NaiveDateTime, Date, Time] do
    defimpl ExMatchers.Matchable, for: t do
      def mismatches(%unquote(t){} = a, %unquote(t){} = b) do
        if unquote(t).compare(a, b) == :eq do
          []
        else
          [%ExMatchers.Mismatch{message: "Not equal"}]
        end
      end

      def mismatches(%unquote(t){}, _),
        do: [%ExMatchers.Mismatch{message: "Not a #{inspect(unquote(t))}"}]
    end
  end

  defimpl ExMatchers.Matchable, for: Any do
    def mismatches(a, a), do: []
    def mismatches(_, _), do: [%ExMatchers.Mismatch{message: "Literals do not match"}]
  end
end
