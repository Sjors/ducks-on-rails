class Figures::CapturesController < ApplicationController
  def index
    @species = Species.find(params[:species_id])
    generate_map 
    render :action => 'show'
  end

  def download
    generate_map "pdf"
    send_file "public/" + @figure_url, :filename => "Captures " + @species.id + ".pdf" 
  end

  def draw_map
    render :text => "
      <img src='#{@figure_url}' onload='EnableSettings()' alt='Map of European captures of #{@species.id}.'>
    "
  end 

  def regenerate_map
    # which summer months?
    smonths = []
    if (params[:smonth][:apr] == "1")  then smonths << 4 end
    if (params[:smonth][:may] == "1")  then smonths << 5 end
    if (params[:smonth][:jun] == "1")  then smonths << 6 end
    if (params[:smonth][:jul] == "1")  then smonths << 7 end
    if (params[:smonth][:aug] == "1")  then smonths << 8 end
    if (params[:smonth][:sep] == "1")  then smonths << 9 end
    
    # which winter months?
    wmonths = []
    if (params[:wmonth][:jan] == "1")  then wmonths << 1 end
    if (params[:wmonth][:feb] == "1")  then wmonths << 2 end
    if (params[:wmonth][:mar] == "1")  then wmonths << 3 end
    if (params[:wmonth][:oct] == "1")  then wmonths << 10 end
    if (params[:wmonth][:nov] == "1")  then wmonths << 11 end
    if (params[:wmonth][:jan] == "1")  then wmonths << 12 end

    session[:smonths] = smonths
    session[:wmonths] = wmonths

    generate_map
    draw_map
  end

  def generate_map (type = "png") 
    unless (session[:smonths] and session[:wmonths]) 
      session[:smonths] = [5]
      session[:wmonths] = [1,2,12]
    end

    @smonths = session[:smonths]
    @wmonths = session[:wmonths]
    #@smonths = smonths
    #@wmonths = wmonths
    # Get species
    @species = Species.find(params[:species_id])

    smonthstr = ""
    @smonths.each {|month|
      smonthstr << "sm#{month}"
    }
    wmonthstr = ""
    @wmonths.each {|month|
      wmonthstr << "wm#{month}"
    }
    file = "tmp/captures #{@species.id} #{smonthstr} #{wmonthstr}"
    @figure_url = "/images/captures/#{@species.id} #{smonthstr} #{wmonthstr}." + type

    # Check if the figure already exists
    if !File.exist?("public" + @figure_url) then
        # Create map with coastline
        mapEurope = Gmt::GmtCoast.new(file+".ps")
        mapEurope.regionWest = "#{@species.map_edge.west.to_i}"
        mapEurope.regionEast = "#{@species.map_edge.east.to_i}"
        mapEurope.regionSouth = "#{@species.map_edge.south.to_i}"
        mapEurope.regionNorth = "#{@species.map_edge.north.to_i}"
        #if 
        #    (
        #        (@species.map_edge.east.to_i  - @species.map_edge.west.to_i) * 
        #        (@species.map_edge.north.to_i - @species.map_edge.south.to_i)
        #    ) < 700
        #then
        #  mapEurope.dataResolution = "i"
        #else
        #  mapEurope.dataResolution = "l"
        #end
       
        if (type == "png") then
          mapEurope.dataResolution = "i"
          mapEurope.orientation = "Portrait" 
        else
          mapEurope.dataResolution = "f"
          mapEurope.orientation = "Landscape" 
        end
        
        mapEurope.projection = "Albert"
        mapEurope.projectionLon0 = "3"
        mapEurope.projectionLat0 = "52"
        mapEurope.projectionLat1 = "33"
        mapEurope.projectionLat2 = "45"
          
        mapEurope.projectionWidth = "8i"
        rotation = 0
        mapEurope.unit = ""

        mapEurope.politicalBoundaries = "-N1/0.25p,-"
        mapEurope.rivers = "-I1/0.5p,blue -I2/0.1p,blue"
        mapEurope.eof = false
        
        mapEurope.write
        
        # Winter captures
        winter = Gmt::GmtXy.new(file+".ps")
        winter.data = @species.getCaptures(@wmonths,0.2)
        winter.symbolType = "Circle"
        winter.fillRed = "200"
        winter.fillGreen = "0"
        winter.fillBlue = "0"
        winter.eof = false
        winter.outline = true
        
        winter.write

        # Summer captures
        data = @species.getCaptures(@smonths,0.4)
        summer = Gmt::GmtXy.new(file+".ps")
        summer.data = data 
        summer.symbolType = "Diamond"
        summer.fillRed = "100"
        summer.fillGreen = "255"
        summer.fillBlue = "100"
        summer.filling = true
        summer.outline = true
        summer.write

        if (type == "png") then
          # Convert image to png and resize
          
          #system "convert \"#{file}\" \"#{file}.png\""
          
          # ps2raster does not like long file names
          system "mv \"#{file}.ps\" bla.ps" 
          system "ps2raster bla.ps -A -Tg -E80"
          
          #system "mv bla.png \"#{file}.png\"" 
          system "mv bla.png 'public/#{@figure_url}'" 


          #figure = ImageList.new file + ".png"
          
          #thumb = figure.rotate(rotation).scale(0.3)
          #thumb.write "public/" + @figure_url
          system "rm bla.ps"
          #system "rm \"#{file}.png\""
        else
          # Convert fom postscript to pdf.
          system "ps2pdf \"#{file}.ps\" \"public/#{@figure_url}\""
          system "rm \"#{file}.ps\"" 
        end
    end
  end
end  
