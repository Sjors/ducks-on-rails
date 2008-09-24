class NavigationController < ApplicationController
  def recapture_condition_countries
    @species = Species.find(params['species_id'])
    @countries = Country.captures(@species.id)
    
    max_captures = (@countries.transpose.last.max {|a,b| a.to_f <=> b.to_f}).to_f 

    countries_iso_string = @countries.transpose.first * ""
    country_values = @countries.transpose.last
    country_values_f = country_values.map do |val|
      (Math.log(val.to_f) / Math.log(max_captures) * 100.0).to_i
    end
    countries_values_string =  country_values_f * ","

    # Map of the world with the countries
    # Uses the Google Chart API:
    # http://code.google.com/apis/chart/#maps
    @figure_url = "http://chart.apis.google.com/chart?cht=t&chs=440x220&chd=s:_&chtm=world&chco=f5f5f5,edf0d4,6c9642,13390a&chld=" + countries_iso_string + "&chd=t:" + countries_values_string + "&chtm=europe"


  
    render :action => 'recapture_condition_select_country'
  end
#    @monthly_captures = []
#    @monthly_condition = []
#    @monthly_death = []
#    @figure_urls = []
#    for country in @countries do
#      figure_urls_country = []
#      res = generate "captures", country[0]
#      figure_urls_country << res[0]
#      @monthly_captures += res[1]
#      
#      res = generate "condition", country[0]
#      figure_urls_country << res[0]
#      @monthly_condition += res[1]
#      
#      res =  generate "death", country[0]
#      figure_urls_country << res[0]
#      @monthly_death += res[1]
#
#      @figure_urls << figure_urls_country
#    end

#  def generate (figure, country, type = "png")
#    case figure
#    when "captures" 
#      figure_url = "/images/country_monthly_captures/#{@species.id} #{country}." + type 
#      captures_this_month = Country.monthly_captures(country, @species.id)
#      make_figure(figure_url, captures_this_month, ["Young", "Adult", "Unknown"],["light_blue","dark_blue","grey"], type)
#      return [figure_url, captures_this_month]
#    when "condition" 
#      figure_url = "/images/country_monthly_condition/#{@species.id} #{country}." + type 
#      condition_this_month = Country.monthly_recaptures_condition(country, @species.id)
#      make_figure(figure_url, condition_this_month, ["Dead", "Sick", "Alive", "Unknown"],["red", "yellow", "dark_green", "grey"], type)
#      return [figure_url, condition_this_month]
#    when "death"
#      figure_url = "/images/country_monthly_death/#{@species.id} #{country}." + type
#      death_this_month = Country.monthly_recaptures_death(country, @species.id)
#      make_figure(figure_url, death_this_month, ["Shot","Killed","Accident","Natural","Preditor","Unknown"],["red", "yellow", "magenta" ,"dark_green", "light_green","grey"], type)
#      return [figure_url, death_this_month]
#    end
#  end
#
#  def make_figure(figure_url, month_data, labels, colors, type)
#      # check if figure already exists
#      if !File.exist?("public" + figure_url) then
#
#        months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
#
#        inputFileName = "tmp/gnuplot.dat"
#        file = File.open( inputFileName, "w") 
#        file.print "
## stacked variable-height bar graph, courtesy of Barb Cutler
#=stacked"
#        for label in labels do
#          file.print ";" + label
#        end
#        file.print "
#colors="
#        first = true
#        for color in colors do
#          if first == false then
#            file.print "," 
#          else
#            first = false
#          end
#          file.print color
#        end
#        file.print "
#legendx=7000
#legendy=500
#=table
#=norotate
#=nogridy
#=noupperright
#yformat=%g
#xlabel=Month
#ylabel=Captures
#extraops=set size 1,1.4
#"
#        for i in (0..11) do
#          captures = month_data.select {|v| v[0] == (i+1).to_s}
#          if(captures != []) then 
#            file.print "#{months[i]} " 
#            j=0
#            for label in labels do
#              j=j+1
#              file.print "#{captures[0][j]} "
#            end
#            file.print "
#"
#          else
#            file.print "#{months[i]} "
#            for label in labels do
#              file.print "0 "
#            end
#            file.print "
#"
#          end
#        end
#
#        file.close
#
#        system "perl ./bargraph.pl -" + type + " \"#{inputFileName}\" > \"public#{figure_url}\""
#        if (type == "png") then
#          # Make it smaller:
#          system "mogrify -resize 600x300 \"public#{figure_url}\""
#        end
#        #system "rm #{inputFileName}"
#      end
#  end
end

