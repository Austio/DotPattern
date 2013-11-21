module Pattern

  def self.impossible
     [["19","5"],["17","4"],["13","2"],["28","5"],["39", "6"],["37","5"],["31","2"],["46","5"],["64","5"],["79","8"],["73","5"],["71","4"],["82","5"],["97","8"],["93","6"], ["91","5"]]
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
    total = @good_routes + @impossible_routes + @inconvenient_routes
    good_convenient = @good_routes
    good_inconvenient = @good_routes + @inconvenient_routes
    impossible = @impossible_routes
    puts "#{total_selections}, #{total},#{good_convenient} (#{Pattern.calculate(total,good_convenient)}),#{good_inconvenient} (#{Pattern.calculate(total,good_inconvenient)}), #{impossible} (#{Pattern.calculate(total,impossible)})"
    #puts "#{total_selections} - Total Dot Selections in Route"
    #puts "#{@good_routes + @impossible_routes + @inconvenient_routes} - Total Routes"
    #puts "#{@good_routes} - Good and Not Inconvenient Routes"
    #puts "#{@impossible_routes} - Impossible Routes"
    #puts "#{@inconvenient_routes} - Inconvenient Routes"

  end

  def self.calculate(routes,portion)
    percent = ((portion.to_f/routes.to_f).round(4.0)*100).to_s
    return "#{percent}%"

  end

  
  def self.test_if_possible(current_route)
    if current_route.length == 1
      return true
    end

    possible = true

    #impossible is an array of arrays, the first element is the impossible route.  The second is the dot that would make it possible
    #so for example, with our ["19","5"] example, it is impossible unless "5" comes before "19".  if our route was "325198".  It would find the route "19" and then check for "5"
    #in the string preceding the "19"
    #by splitting the string at "19", it will return ["325","8"].  Since the first route includes a "5", it is actually possible because you can get from 1 to 9 if 5 is already selected
    Pattern.impossible.each do |impossible_route_pair|

      if current_route.include? impossible_route_pair.first
        if possible
          split_route = current_route.split(impossible_route_pair.first)
          case split_route.length
            when 0
              #this will only happen on a 2 digit route, the route "19" split by "19" is []
              possible = false
            else
              #we either have a 1 or 2 length array, 1 length if the "19" is at the string tail, 2 if it is anywhere else.  The first element is the digits before the "19"
              # so check if the first element has any dots that would allow this route to be possible
              possible = false unless split_route.first.include? impossible_route_pair.second
          end
        end
      end

    end
    possible
  end

  #Cycles through all given routes given a number of selections
  #total_selections_remaining = Number of selections remaining in the given route, so 3 here would give you 3 more dot selections in your route
  #remaining_dots = Keeps track of local possible dots remaining to choose from
  #current_route = Keeps track of the dots taken in the current route
  def self.test_route(total_selections_remaining, remaining_dots = "987654321", current_route = '')
    if remaining_dots.empty? or total_selections_remaining == 0
   
      #check if the route is inconvenient or possible
      possible = Pattern.test_if_possible(current_route)
      inconvenient = Pattern.inconvenient.any? {|inconvenient_route| current_route.include? inconvenient_route}

      if not possible
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
