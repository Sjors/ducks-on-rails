class SpeciesController < ApplicationController
  def index
    @species = Species.find_by_capture_count
    render :action => 'list'
  end
end
