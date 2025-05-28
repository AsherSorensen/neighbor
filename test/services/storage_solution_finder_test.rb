require "test_helper"

class StorageSolutionFinderTest < ActiveSupport::TestCase
  test "finds no solutions with the empty implementation" do
    finder = StorageSolutionFinder.new([], [])
    solutions = finder.find_solutions

    assert_empty solutions
  end

  test "finds solution for single vehicle" do
    vehicles = [{ length: 10, quantity: 1 }]
    listings = [
      {
        "id" => "listing1",
        "length" => 20,
        "width" => 20,
        "location_id" => "loc1",
        "price_in_cents" => 1000
      }
    ]

    finder = StorageSolutionFinder.new(vehicles, listings)
    solutions = finder.find_solutions

    assert_not_empty solutions
    assert_equal "loc1", solutions.first[:location_id]
    assert_includes solutions.first[:listing_ids], "listing1"
    assert_equal 1000, solutions.first[:total_price_in_cents]
  end
end 