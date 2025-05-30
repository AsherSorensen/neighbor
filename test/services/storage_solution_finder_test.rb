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

  test "finds cheapest solution when multiple options exist" do
    vehicles = [{ length: 10, quantity: 1 }]
    listings = [
      {
        "id" => "expensive",
        "length" => 20,
        "width" => 20,
        "location_id" => "loc1",
        "price_in_cents" => 2000
      },
      {
        "id" => "cheap",
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
    assert_includes solutions.first[:listing_ids], "cheap"
    assert_equal 1000, solutions.first[:total_price_in_cents]
  end

  test "finds solutions across multiple locations" do
    vehicles = [{ length: 10, quantity: 1 }]
    listings = [
      {
        "id" => "loc1_listing",
        "length" => 20,
        "width" => 20,
        "location_id" => "loc1",
        "price_in_cents" => 1000
      },
      {
        "id" => "loc2_listing",
        "length" => 20,
        "width" => 20,
        "location_id" => "loc2",
        "price_in_cents" => 1500
      }
    ]

    finder = StorageSolutionFinder.new(vehicles, listings)
    solutions = finder.find_solutions

    assert_equal 2, solutions.length
    assert_equal "loc1", solutions.first[:location_id]
    assert_equal "loc2", solutions.last[:location_id]
    assert solutions.first[:total_price_in_cents] < solutions.last[:total_price_in_cents]
  end

  test "handles multiple vehicles at same location" do
    vehicles = [
      { length: 10, quantity: 1 },
      { length: 15, quantity: 1 }
    ]
    listings = [
      {
        "id" => "listing1",
        "length" => 20,
        "width" => 20,
        "location_id" => "loc1",
        "price_in_cents" => 2000
      },
      {
        "id" => "listing2",
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
    assert_equal 1, solutions.first[:listing_ids].length
    assert_equal ["listing2"], solutions.first[:listing_ids]
    assert_equal 1000, solutions.first[:total_price_in_cents]
  end

  test "handles vehicles that don't fit in any listing" do
    vehicles = [{ length: 100, quantity: 1 }]
    listings = [
      {
        "id" => "small",
        "length" => 20,
        "width" => 20,
        "location_id" => "loc1",
        "price_in_cents" => 1000
      }
    ]

    finder = StorageSolutionFinder.new(vehicles, listings)
    solutions = finder.find_solutions

    assert_empty solutions
  end

  test "handles multiple listings at the same location with multiple vehicles" do
    vehicles = [{ length: 10, quantity: 5 }]
    listings = [
      {
        "id" => "1",
        "length" => 10,
        "width" => 50,
        "location_id" => "loc1",
        "price_in_cents" => 3000
      },
      {
        "id" => "2",
        "length" => 50,
        "width" => 10,
        "location_id" => "loc2",
        "price_in_cents" => 4000
      },
      {
        "id" => "3",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "4",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "5",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "6",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "7",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      } 
    ]

    finder = StorageSolutionFinder.new(vehicles, listings)
    solutions = finder.find_solutions
    assert_not_empty solutions
    assert_equal "loc1", solutions[0][:location_id]
    assert_equal "loc2", solutions[1][:location_id]
    assert_equal "loc3", solutions[2][:location_id]
    assert_equal 1, solutions[0][:listing_ids].length
    assert_equal 3000, solutions[0][:total_price_in_cents]
    assert_equal 1, solutions[1][:listing_ids].length
    assert_equal 4000, solutions[1][:total_price_in_cents]
    assert_equal 5, solutions[2][:listing_ids].length
    assert_equal 5000, solutions[2][:total_price_in_cents]
  end

  test "more width tests" do
    vehicles = [{ length: 10, quantity: 4 }, { length: 40, quantity: 1 }]
    listings = [
      {
        "id" => "1",
        "length" => 40,
        "width" => 20,
        "location_id" => "loc1",
        "price_in_cents" => 3000
      },
      {
        "id" => "2",
        "length" => 40,
        "width" => 50,
        "location_id" => "loc2",
        "price_in_cents" => 4000
      },
      {
        "id" => "3",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "4",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "5",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "6",
        "length" => 10,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      },
      {
        "id" => "7",
        "length" => 40,
        "width" => 10,
        "location_id" => "loc3",
        "price_in_cents" => 1000
      } 
    ]

    finder = StorageSolutionFinder.new(vehicles, listings)
    solutions = finder.find_solutions

    assert_not_empty solutions
    assert_equal "loc1", solutions[0][:location_id]
    assert_equal "loc2", solutions[1][:location_id]
    assert_equal "loc3", solutions[2][:location_id]
    assert_equal 1, solutions[0][:listing_ids].length
    assert_equal 3000, solutions[0][:total_price_in_cents]
    assert_equal 1, solutions[1][:listing_ids].length
    assert_equal 4000, solutions[1][:total_price_in_cents]
    assert_equal 5, solutions[2][:listing_ids].length
    assert_equal 5000, solutions[2][:total_price_in_cents]
  end
end 