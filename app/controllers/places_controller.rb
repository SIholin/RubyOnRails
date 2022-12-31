class PlacesController < ApplicationController
  before_action :set_place, only: %i[show]

  def index
  end

  def search
    c = params[:city]
    @places = BeermappingApi.places_in(c)
    @weather = BeermappingApi.weather(c)
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = c
      render :index, status: 418
    end
  end

  def show
  end

  def set_place
    places = Rails.cache.fetch(session[:city])
    pl = places.select { |p| p.id == params[:id] }.first
    @place = Place.new(pl)
  end
end
