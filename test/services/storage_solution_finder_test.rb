require "test_helper"

class StorageSolutionFinderTest < ActiveSupport::TestCase
  setup do
    @vehicles = [
      { length: 10, quantity: 1 },
      { length: 20, quantity: 2 }
    ]

    @listings = []
  end

  test "finds no solutions with the empty implementation" do
    finder = StorageSolutionFinder.new(@vehicles, @listings)
    solutions = finder.find_solutions

    assert_empty solutions
  end
end 