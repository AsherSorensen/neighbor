class SearchController < ApplicationController
  def search
    listings = load_listings

    finder = StorageSolutionFinder.new(vehicles_params, listings)
    results = finder.find_solutions
    render json: results
  end

  private

  def vehicles_params
    params.require(:search).require(:_json).map do |p|
      p.permit(:length, :quantity).to_h.symbolize_keys
    end
  end

  def load_listings
    file_path = Rails.root.join("app", "data", "listings.json")
    JSON.parse(File.read(file_path))
  end
end
