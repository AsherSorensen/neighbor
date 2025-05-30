class StorageSolutionFinder
  def initialize(vehicles, listings)
    @vehicles = vehicles
    @listings = listings
  end

  def find_solutions
    listings_by_location = @listings.group_by { |listing| listing["location_id"] }
    @flat_vehicles = @vehicles.flat_map { |v| [ v[:length] ] * v[:quantity] }.sort_by { |x| -x }

    results = []

    listings_by_location.each do |location_id, location_listings|
      solution = find_cheapest_solution(location_listings)

      if solution
        results << {
          location_id: location_id,
          listing_ids: solution[:listing_ids],
          total_price_in_cents: solution[:total_price]
        }
      end
    end

    results.sort_by { |result| result[:total_price_in_cents] }
  end

  private

  class Listing
    attr_reader :id, :price_in_cents

    def self.from_listing_data(data)
      new(
        id: data["id"],
        length: [ data["length"], data["width"] ].max,
        width: [ data["length"], data["width"] ].min,
        price_in_cents: data["price_in_cents"]
      )
    end

    def initialize(id:, length:, width:, price_in_cents:)
      @id = id
      @length = length
      @used_length = [ 0 ] * (width / 10)
      @width = width
      @price_in_cents = price_in_cents
    end

    def fit_vehicle(vehicle_length)
        return false if vehicle_length > @length

      @used_length.each_with_index do |used_length, i|
        if vehicle_length + used_length <= @length
          @used_length[i] += vehicle_length
          return self
        end
      end

      false
    end
  end

  def find_cheapest_solution(listings)
    best_price = Float::INFINITY
    best_listings = []

    listing_permutations = listings.permutation.to_a

    listing_permutations.each do |listing_permutation|
    catch :invalid_solution do
        total_price = 0
        used_listings = Set.new
        listing_objs = listing_permutation.map { |l| Listing.from_listing_data(l) }

        @flat_vehicles.each do |vehicle|
            listing = listing_objs.find do |l|
                next if l.price_in_cents > best_price
                l.fit_vehicle(vehicle)
            end

            throw :invalid_solution unless listing

            unless used_listings.include?(listing.id)
                used_listings.add(listing.id)
                total_price += listing.price_in_cents
                next if total_price > best_price
            end
        end

        if total_price < best_price
            best_price = total_price
            best_listings = used_listings.to_a
        end
    end
    end

    return nil if best_price == Float::INFINITY

    {
      listing_ids: best_listings,
      total_price: best_price
    }
  end
end
