module Pattern

  def self.impossible
     ["19","17","13","28","39","37","31","46","64","79","73","71","82","97", "93", "91"]
  end

  def self.inconvenient
     ["18","16","29","27","38","34","49","43","67","61","76","72","83","81","94","92"]
  end

  #takes a number of selections and calculates the number of possible patterns, from 2 to that number
  #so a 4 here would calculate the 2, 3, and 4 dot selections in a route
  def self.work(total_selections)
    if total_selections == 1
      return
    else
      Pattern.work(total_selections-1)
      Pattern.determine_routes(total_selections)
      puts ''
    end
  end


  #spits out the number of dots in the selection, total good, impossible and inconvenient routes
  def self.determine_routes(total_selections)
    @impossible_routes = 0
    @inconvenient_routes = 0
    @good_routes = 0

    Pattern.test_route(total_selections)

    puts "#{total_selections} - Total Dot Selections in Route"
    puts "#{@good_routes + @impossible_routes + @inconvenient_routes} - Total Routes"
    puts "#{@good_routes} - Good and Not Inconvenient Routes"
    puts "#{@impossible_routes} - Impossible Routes"
    puts "#{@inconvenient_routes} - Inconvenient Routes"

  end


  #Cycles through all given routes given a number of selections
  #total_selections_remaining = Number of selections remaining in the given route, so 3 here would give you 3 more dot selections in your route
  #remaining_dots = Keeps track of local possible dots remaining to choose from
  #current_route = Keeps track of the dots taken in the current route
  def self.test_route(total_selections_remaining, remaining_dots = "987654321", current_route = '')
    if remaining_dots.empty? or total_selections_remaining == 0
      impossible = Pattern.impossible.any? {|route| current_route.include? route}
      inconvenient = Pattern.inconvenient.any? {|route| current_route.include? route}

      if  impossible
        @impossible_routes += 1
      elsif inconvenient
        @inconvenient_routes += 1
      else
        @good_routes += 1
      end
    else
      remaining_dots.each_char {|dot| test_route(total_selections_remaining - 1, remaining_dots.gsub(dot,''),current_route + dot)}
    end
  end
end
