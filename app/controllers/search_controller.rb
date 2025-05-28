class SearchController < ApplicationController
  def search
    vehicles = search_params
    listings = load_listings

    finder = StorageSolutionFinder.new(vehicles, listings)
    results = finder.find_solutions
    render json: results
  end

  private

  def search_params
    params.require(:vehicles).map do |vehicle|
      vehicle.permit(:length, :quantity).to_h
    end
  end

  def load_listings
    file_path = Rails.root.join('app', 'data', 'listings.json')
    JSON.parse(File.read(file_path))
  end
end 