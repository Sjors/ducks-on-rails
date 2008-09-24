class GchartController < ApplicationController
  # Shows charts using the Google Chart API  

  # We use the Google Chart API: http://code.google.com/apis/chart/
  # And a Ruby wrapper: http://code.google.com/p/gchartrb/
  require 'rubygems'
  require 'google_chart'

  def capturesperyear
    # Shows a chart with the total captures per decade of the current species.

    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Captures per year of"    
    @chart_description = "Number of " + @species.name_en.downcase + " ringed in The Netherlands."    

    GoogleChart::LineChart.new('700x200', "", true) do |lcxy|
      # Create an array with x,y data points
      data = (1936..2006).map do |year|
          [
            year,
            @species.capturesFromTo(year, year, "all")[0].to_f
          ]
      end
      
      # We need to scale some things between 0 and 100.
      # For that I look up the max value.      
      max_captures = data.max {|a,b| a[1] <=> b[1]} [1]
      # We use text encoding and scale all values between 0 and 100
      lcxy.data_encoding = :text
      data_scaled = data.map do |point|
        [
          (point[0] - 1936.0) / 70.0 * 100.0,
          point[1] / max_captures * 100.0 
        ]
      end

      # Plot the data array, specify color and add species name to legend: 
      lcxy.data @species.name_en, data_scaled, '4d89f0'

      # Axis
      lcxy.axis :y, :range => [0,max_captures]
      lcxy.axis :x, :range => [1940,2000], :alignment => :center

      lcxy.grid :x_step => 10.0/6.0*10


      # Generate figure URL for the Google Chart API
      @figure_url = lcxy.to_url
    end    
    
    # And show the page:
    render :action => 'show'
  end
  
  def sex
    # Shows a chart with the sex distribution of ducks captures in The Netherlands.
    
    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Sex distribution of"
    @chart_description = "Sex distribution of " + @species.name_en.downcase + " ringed in The Netherlands after 1958."    

    # Create barchart
    bc = GoogleChart::BarChart.new('300x200', "", :vertical, true)
    bc.data_encoding = :text    

    bc.data "male", [@species.sex('male')], '5555aa'
    bc.data "unknown", [@species.sex('unknown')], 'cccccc'
    bc.data "female", [@species.sex('female')], 'ff9999'
    
    # Axis:    
    bc.axis :y

    # Generate figure URL for the Google Chart API
    @figure_url = bc.to_url
    
    # And show the page:
    render :action => 'show'
  end
  
  def age
    # Shows a chart with the age distribution of ducks captures in The Netherlands.
    
    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Age distribution of"
    @chart_description = "Age distribution of " + @species.name_en.downcase + " ringed in The Netherlands after 1958."    

    # Create barchart
    bc = GoogleChart::BarChart.new('400x200', "", :vertical, true)
    
    bc.data_encoding = :text    
    
    # Axis:    
    bc.axis :y
  
    bc.data "Pullus", [@species.age('pullus')], 'FFE4E1'
    bc.data "1st yr", [@species.age('1')], '1E90FF'
    bc.data "2nd yr", [@species.age('2')], '483D8B'
    bc.data "> 2nd yr", [@species.age('>2')], '000000'
    bc.data "Unknown", [@species.age('unknown')], 'CCCCCC'

    # Generate figure URL for the Google Chart API
    @figure_url = bc.to_url
    
    # And show the page:
    render :action => 'show'
  end

  def top_decoys
    # Get current species
    @species = Species.find(params[:species_id])
   
    # Get decoys:
    bakker = DuckDecoy.find(:first, :conditions => {:naam => "BAKKERSWAAL"})
    nieuwe = DuckDecoy.find(:first, :conditions => {:naam => "NIEUWE-KOOI", :gemeente => "VUGHT"})
    rhoon = DuckDecoy.find(:first, :conditions => {:naam => "RHOON"})
    
    months = [[1,"Jan"], [2,"Feb"], [3,"Mar"], [4,"Apr"], [5,"May"], [6,"Jun"], [7,"Jul"], [8,"Aug"], [9,"Sep"], [10,"Oct"], [11,"Nov"], [12,"Dec"]]

    # Set chart title
    @chart_title = "Bakkerswaal decoy for"
    @chart_description = "Duck decoy Bakkerswaal activity between 2000 and 2006: the average number of captures for each month in this period."
 
    # Create barchart
    lcxy = GoogleChart::LineChart.new('400x150', "", true)

    # Create an array with x,y data points
    data = months.map do |month|
        [
          month[0].to_f,
          bakker.CapturesPerMonthAvg(@species.id, month[0], 2000, 2006).to_f
        ]
    end
    
    # We need to scale some things between 0 and 100.
    # For that I look up the max value.      
    max_captures = data.max {|a,b| a[1] <=> b[1]} [1]
    # We use text encoding and scale all values between 0 and 100
    lcxy.data_encoding = :text
    data_scaled = data.map do |point|
      [
        (point[0] - 1.0) / 11.0 * 100.0,
        point[1] / max_captures * 100.0 
      ]
    end

    # Plot the data array, specify color and add species name to legend: 
    lcxy.data @species.name_en, data_scaled, '4d89f0'

    # Axis
    lcxy.axis :y, :range => [0,max_captures]
    lcxy.axis :x, :range => [0,11], :alignment => :center, :labels => months.transpose.last

    # Shape markers
    (0..11).each do |i|
      lcxy.shape_marker :square, :color => "4d89f0", :data_set_index => 0, :data_point_index => i, :pixel_size => 5
    end
    # Generate figure URL for the Google Chart API
    @figure_url = lcxy.to_url

    # And show the page:
    render :action => 'show'
  end
  
  def catch_method
    # Shows a chart with the percentage of captures in duck decoys compared to other methods in The Netherlands.
    
    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Catching method of"
    @chart_description = "Catching method distribution of " + @species.name_en.downcase + " ringed in The Netherlands after 1958."    

    # Create barchart
    bc = GoogleChart::BarChart.new('300x200', "", :vertical, true)
    bc.data_encoding = :text    

    bc.data "decoy", [@species.catch_method('decoy')], 'ff0000'
    bc.data "other", [@species.catch_method('other')], 'cccccc'
    
    # Axis:    
    bc.axis :y

    # Generate figure URL for the Google Chart API
    @figure_url = bc.to_url
    
    # And show the page:
    render :action => 'show'
  end

  def countries
    # Shows a pie chart with destination countries of ducks that were
    # ringed in The Netherlands. 
    
    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Destination countries of"
    @chart_description = "Destination countries of " + @species.name_en.downcase + " ringed in The Netherlands, all time. Only countries with more than 10 recaptures."    

    # Create piechart
    bc = GoogleChart::PieChart.new('600x300', "" , false)
 
    # Get number of recaptures per country:
    countries = @species.recapture_countries
    total = countries.transpose.last.sum
    
    countries.each do |country| 
      bc.data "#{Country.find(country[0]).name} (#{country[1].to_i})" , country[1]/total  
    end
    
    # Generate figure URL for the Google Chart API
    @figure_url = bc.to_url
    
    # And show the page:
    render :action => 'show'
  end

  def speed
    # Shows a chart with the speed of this species. Several methods
    # are used to calculate this speed. 
    
    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Speed of"
    @chart_description = "Speed (km / day) of " + @species.name_en.downcase + " departing from The Netherlands. On the left is the maximum recorded speed. Next to it is the average speed of all flights that took 3 days or less (probably more reliable than maximum speed. The 3rd and 4th bar show the average autumn and spring migration speed. Error bars are not given."

    # Create barchart
    bc = GoogleChart::BarChart.new('300x400', "", :vertical, false)
    bc.data_encoding = :text 
    
    max = @species.speed('max')
    threedays = @species.speed('3days')
    autumn = @species.speed('autumn')
    spring = @species.speed('spring')

    bc.data "Max", [max[0]], 'B8860B'
    bc.data "3 days", [threedays[0]], 'cccccc'
    bc.data "Autumn", [autumn[0]], 'ff5555'
    bc.data "Spring", [spring[0]], '55ff55'
 
    # Axis:    
    bc.axis :y, :range => [0, max[0]]
    bc.axis :x, :labels => [@species.name_en]

    # Generate figure URL for the Google Chart API
    @figure_url = bc.to_url
    
    # And show the page:
    render :action => 'show'
  end

  def survival
    # Shows a chart of the (LN of the) number of dead recoveries N years after ringing. Its slope can be used to estimate survival.

    # Get current species
    @species = Species.find(params[:species_id])

    # Set chart title
    @chart_title = "Yearly survival of"    
    @chart_description = "Dead recoveries of " + @species.name_en.downcase + " ringed in The Netherlands. At year 0 are all #{@species.name_en.downcase} that were recovered in the same year they were ringed. At year 1 are those that were recovered a year after they were ringed. Etc. The slope of the graph can be used to estimate the yearly survival chance."   
 GoogleChart::LineChart.new('400x200', "", true) do |lcxy|
      # Create an array with x,y data points
      data = (0..10).map do |year|
          [
            year,
            @species.survival(year).to_f
          ]
      end
      
      # We need to scale some things between 0 and 100.
      # For that I look up the max value.      
      max_captures = data.max {|a,b| a[1] <=> b[1]} [1]
      # We use text encoding and scale all values between 0 and 100
      lcxy.data_encoding = :text
      data_scaled = data.map do |point|
        [
          (point[0]) / 10.0 * 100.0,
          Math.log(point[1]) / Math.log(max_captures) * 100.0 
        ]
      end

      # Plot the data array, specify color and add species name to legend: 
      lcxy.data @species.name_en, data_scaled, '4d89f0'

      # Scaling the axis to a logarithmic scale is a bit more tricky.
      labelsy_val = []
      labelsy_pos = []
      a = 1.0
      while (a < max_captures) do
        labelsy_val << a.to_i
        labelsy_pos << Math.log(a) / Math.log(max_captures) * 100
        a *= 10.0
      end

      if (max_captures / a * 10.0 > 1.5) then 
        labelsy_val << max_captures.to_i
        labelsy_pos << [100] 
      end

      # Axis
      lcxy.axis :y, :labels => labelsy_val, :positions => labelsy_pos
      lcxy.axis :x, :range => [0,10], :alignment => :center

      lcxy.grid :x_step => 10


      # Generate figure URL for the Google Chart API
      @figure_url = lcxy.to_url
    end    
    
    # And show the page:
    render :action => 'show'
  end
  
  def capture_condition
    months = [[1,"Jan"], [2,"Feb"], [3,"Mar"], [4,"Apr"], [5,"May"], [6,"Jun"], [7,"Jul"], [8,"Aug"], [9,"Sep"], [10,"Oct"], [11,"Nov"], [12,"Dec"]]
    
    # Get current species
    @species = Species.find(params[:species_id])
    
    # Get country
    @country = Country.find(params[:country])

    # Set chart title
    @chart_title = "Capture condition in #{@country.name} of"
    @chart_description = "Capture condition of " + @species.name_en.downcase + " departing from The Netherlands, arriving in #{@country.name}. The height of the bars represents the average number of captures per month over the period 1936-2006." 
 
    # Create barchart
    bc = GoogleChart::BarChart.new('700x400', "", :vertical, true)
    bc.data_encoding = :text 
   
    dead = months.map do |month|
      @species.capture_condition(@country.id, month[0], 'dead')
    end
    alive = months.map do |month|
      @species.capture_condition(@country.id, month[0], 'alive')
    end

    bc.data "Dead", dead, 'FF0000'
    bc.data "Alive", alive, '00FF00'
 
    # Axis:    
    bc.axis :y, :range => [0, (dead + alive).max]
    bc.axis :x, :labels => months.transpose.last 

    # Generate figure URL for the Google Chart API
    @figure_url = bc.to_url
    
    # And show the page:
    render :action => 'show'
  end
end
