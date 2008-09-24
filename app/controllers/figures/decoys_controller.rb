class Figures::DecoysController < ApplicationController
  def index
    # Create figure and determine URL
    generate_map

    # And show the page:
    render :action => 'show'
  end

  def download
    if (params[:figure]=="map") then
      generate_map "pdf"
    send_file "public/" + @figure_url, :filename => "Decoys " + @species.id + ".pdf" 
    else 
      generate_chart "pdf"
    send_file "public/" + @chart_url, :filename => "Decoys chart " + @species.id + ".pdf" 
    end
  end

  private

  def generate_map (type = "png")
    # Get species
    @species = Species.find(params[:species_id])

    # Location of temporary postscript file and final png or pdf file
    file = "tmp/decoy #{@species.id}.ps"
    @figure_url = "images/decoys/" + @species.id + "." + type

    # Check if the figure already exists
    if !File.exist?("public/" + @figure_url) then

        # Create map with coastline
        mapNL = Gmt::GmtCoast.new(file)
        mapNL.eof = false
        if (type == "pdf") then
          mapNL.dataResolution = "f" # Full resolution maps for pdf output
        end

        # Put duck decoys on the map
        decoysNL = Gmt::GmtXy.new(file)
        decoysNL.data = @species.getDuckDecoySizes
        decoysNL.eof = false
        
        # Put non duck decoy captures on the map
        notDecoysNL = Gmt::GmtXy.new(file)
        notDecoysNL.data = @species.getNonDuckDecoyCaptureSizes
        notDecoysNL.symbolType = "Circle"
        notDecoysNL.filling = false

        # Write the map files
        @gmtCmd = decoysNL.command + "<br>" + notDecoysNL.command
        mapNL.write
        decoysNL.write
        notDecoysNL.write

        # Fix bounding box
        system "epstool -c -b \"#{file}\""

        if (type == "png") then
          # Convert image to png and resize
          system "convert \"#{file}\" -resize 300x423 \"public/#{@figure_url}\""
          system "rm \"#{file}.png\""
        else
          # Convert fom postscript to pdf.
          system "ps2pdf \"#{file}\" \"public/#{@figure_url}\""
        end
        # Clean up
        system "rm \"#{file}\""
    end
  end
end
