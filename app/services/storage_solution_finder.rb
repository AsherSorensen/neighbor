class StorageSolutionFinder
  def initialize(vehicles, listings)
    @vehicles = vehicles
    @listings = listings
  end

  def find_solutions
    listings_by_location = @listings.group_by { |listing| listing['location_id'] }
    
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

  def find_cheapest_solution(listings)
    sorted_listings = listings.sort_by { |l| l['price_in_cents'].to_f }
    used_listings = []
    total_price = 0
    
    @vehicles.each do |vehicle|
      vehicle[:quantity].times do
        listing = sorted_listings.find do |l|
          l['length'] >= vehicle[:length] && 
          l['width'] >= 10 &&
          !used_listings.include?(l['id'])
        end
        
        return nil unless listing
        
        used_listings << listing['id']
        total_price += listing['price_in_cents']
      end
    end
    
    {
      listing_ids: used_listings,
      total_price: total_price
    }
  end
end 