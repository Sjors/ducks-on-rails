module Gmt
class GmtCoast
    attr_writer :eof, :bof
    attr_writer :dataResolution
    attr_writer :orientation
    attr_writer :regionWest, :regionEast, :regionNorth, :regionSouth, :unit
    attr_writer :projection, :projectionWidth, :projectionLon0, :projectionLat0, :projectionLat1, :projectionLat2
    attr_writer :politicalBoundaries, :rivers
 
    def initialize(file)
        # The default mode plots a map of The Netherlands
        @file = file

        @projection = "Mercator"
        @projectionScaleOrWidth = "Width"
        @projectionScale = ""
        @projectionWidth = "6"

        @regionUnit = "decimal"
        @regionOrientation = ""
        @regionWest = "3.5"
        @regionEast = "6.5"
        @regionNorth = "53.8"
        @regionSouth = "50.9"

        @orientation = "Portrait"

        @coastlines = true
        @coastlineWidth = "0.05"
        @coastlineWidthUnit = "p"
        @coastlineRed = "100"
        @coastlineGreen = "100"
        @coastlineBlue = "100"
        @coastlineColorUnit = "rgb"
        @coastlineTexture = "."
        @coastlineTextureUnit = "symbols"

        @dryRed = "255"
        @dryGreen ="250"
        @dryBlue = "205"
        
        @wetRed = "240"
        @wetGreen = "248"
        @wetBlue = "255"

        @unit = "i"
        @bof = true
        @eof = true
        @dataResolution = "i"
        @boundaryAnnotationTickmarkIntervals = "20g20" # "5g5"

        # These should become seperate classes
        @politicalBoundaries = "-N1/02.25p,-"
        @rivers = "-I1/0.5p,blue -I2/0.1p,blue -I4/0.05p,blue"

    end

    def command()
        cmd = "pscoast "
        # region
        cmd << "-R#{@regionWest}/#{@regionEast}/#{@regionSouth}/#{@regionNorth} "
        # Projection
        cmd << "-J" 
        if @projection == "Mercator" and @projectionScaleOrWidth == "Width" then 
            cmd << "M" 
        end
        if @projection == "Albert" and @projectionScaleOrWidth == "Width" then 
            cmd << "B" 
            cmd << @projectionLon0 << "/"
            cmd << @projectionLat0 << "/"
            cmd << @projectionLat1 << "/"
            cmd << @projectionLat2 << "/"
        end
        cmd << @projectionWidth + @unit + " " 
        # Landscape or portrait?
        if @orientation == "Portrait" then cmd << "-P " end
        # Politcal boundaries
        cmd << @politicalBoundaries + " "
        # Coastlines
        if @coastlines == true then
            cmd << "-W" + @coastlineWidth + @coastlineWidthUnit + ","
            if @coastlineColorUnit == "rgb" then
              cmd << "#{@coastlineRed}/#{@coastlineGreen}/#{@coastlineBlue}"
            end
            cmd << ",#{@coastlineTexture} "
        end
        # Rivers
        cmd << @rivers + " "
        # Resolution
        cmd << "-D#{@dataResolution} "
        # Boundary annotations and tick marks
        cmd << "-B#{@boundaryAnnotationTickmarkIntervals} "
        # Dry areas
        cmd << "-G#{@dryRed}/#{@dryGreen}/#{@dryBlue} "
        # Wet areas
        cmd << "-S#{@wetRed}/#{@wetGreen}/#{@wetBlue} "

        # Beginning or end of file?
        if @bof == false then cmd << "-O " end
        if @eof == false then cmd << "-K " end
        
        # Destination filename
        if @bof == true then cmd << ">" else cmd << ">>" end
        cmd << " \"#{@file}\""

        return cmd
 
    end
    def write()
        system command
    end
end

class GmtXy
    attr_writer :eof
    attr_writer :bof
    attr_writer :data
    attr_writer :symbolType
    attr_writer :filling, :outline, :fillRed, :fillGreen, :fillBlue
    # It assumes a region and projection has already been 
    # determined in a GmtCoast object.
    def initialize(file)
        @file = file
        @data = [
            [4.68333, 52.3667, 0.50689042022202],
            [5.13333, 52.3, 0.6816735880595],
            [4.8,53.0333,0.32188758248682]
        ]
        @symbols = true
        @symbolSize = false
        @symbolType = "Star"

        @filling = true
        @outline = false
        @fillRed = 255
        @fillGreen = 0
        @fillBlue = 0
        
        @bof = false
        @eof = true
    end

    def command
        # gives the command without the data
        cmd = "psxy -R -J "

        # Symbols
        if @symbols then
            cmd << "-S"
            case @symbolType
                when "Star" 
                    cmd << "a "
                when "Circle" 
                    cmd << "c "
                when "Diamond" 
                    cmd << "d "
            end
        end

        # Filling
        if @filling == true
            cmd << "-G#{@fillRed}/#{@fillGreen}/#{@fillBlue} "
        end
        
        # Outline
        if @outline == true
            cmd << "-W "
        end
          
        # New or existing file?
        if @bof == false then cmd << "-O " end
        # Close file?
        if @eof == false then cmd << "-K " end
        return cmd
    end

    def showData
        str = ""
        @data.each do |row|
            str << row[0].to_s + "\t" + row[1].to_s + "\t" + row[2].to_s + "\n"
        end
        return str
    end

    def write
        if @bof == true then 
            system "echo \"#{showData}\" | #{command} > \"#{@file}\""
        else
            system "echo \"#{showData}\" | #{command} >> \"#{@file}\""
        end
        
    # runs psxy and gives it data through standard input
    # command + data
    end
end


end

