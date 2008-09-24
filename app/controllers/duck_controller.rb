class DuckController < ApplicationController
  layout "duck"
  def index
    @species = Species.find(params['species_id'])
#    @item_pages, @ducks = paginate(
#        :ducks, 
#        :conditions => ["#{:ducks}.#{:sch} = ? AND #{:ducks}.#{:species_id} = ? AND captures > ?",'NLA', @species.id, 1],
#        :include => :capture_count,
#        :per_page => 100,
#        :order => "captures DESC",
#    )
    @ducks = Duck.find(
        :all,
        :ducks,
        :conditions => ["#{:ducks}.#{:sch} = ? AND #{:ducks}.#{:species_id} = ? AND captures > ?",'NLA', @species.id, 1],
        :include => :capture_count,
        :order => "captures DESC",
        :limit => 20
    )
    render :action => 'list'
  end
  def captures
    @sch = params['sch']
    @ringnr = params['ringnr']
      @species = Species.find(params['species_id'])
    
    # Security check:
    # - make sure that we only show the 20 allowed rings
    ducksallowed = Duck.find(
        :all, 
        :ducks,
        :conditions => ["#{:ducks}.#{:sch} = ? AND #{:ducks}.#{:species_id} = ? AND captures > ?",'NLA', @species.id, 1],
        :include => :capture_count,
        :order => "captures DESC",
        :limit => 20
    )
    allowed=false
    for duck in ducksallowed do
      if (duck.sch == @sch and duck.ringnr == @ringnr) then allowed = true end
    end
    if(allowed==true) then
      @duck = Duck.find(@sch + "," + @ringnr)
      @captures = Capture.find(
          :all,  
          :conditions => ["#{:sch} = ? AND #{:ringnr} = ?",@sch, @ringnr]
      )
    else
      render :action => 'dave'
    end
    

    
    
  end
end

