defmodule StructLikeMatcherTest do
  use ExUnit.Case, async: true
  use Machete

  import Machete.Mismatch

  doctest Machete.StructLikeMatcher

  test "produces a useful mismatch for type mismatches" do
    assert %URI{}
           ~>> struct_like(DateTime, %{})
           ~> mismatch(
             "%URI{authority: nil, fragment: nil, host: nil, path: nil, port: nil, query: nil, scheme: nil, userinfo: nil} is not a DateTime"
           )
  end

  test "produces a useful mismatch for field mismatches" do
    assert %URI{}
           ~>> struct_like(URI, %{host: "example.com"})
           ~> mismatch("nil is not equal to \"example.com\"", :host)
  end
end
