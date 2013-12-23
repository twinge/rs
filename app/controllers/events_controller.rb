class EventsController < ApplicationController

  def show
    current_event = Event.where(conference_id: params[:id]).first
    if current_event.nil?
		  render :text => 'No registrants from your conference have registered with Rideshare yet.' and return
    else
      @drivers = Ride.drivers_by_event_id(current_event.id)
      @riders = Ride.riders_by_event_id(current_event.id)
      @hidden_rides = Ride.hidden_drivers_by_event_id(current_event.id)

      if @riders.size == 0 || @drivers.size == 0
        redirect_to :action => :empty
      end

      @drivers.sort! { |a,b| (!a.special_info.blank? && !b.special_info.blank?) || (a.special_info.blank? && b.special_info.blank?)?(a.person.full_name+"" <=> b.person.full_name+""):((a.special_info.blank? && !b.special_info.blank?)?(1):(-1))}
      @riders.sort! { |a,b| (!a.special_info.blank? && !b.special_info.blank?) || (a.special_info.blank? && b.special_info.blank?)?(a.person.full_name+"" <=> b.person.full_name+""):((a.special_info.blank? && !b.special_info.blank?)?(1):(-1))}

      @spaces=0
      @riders_done=0
      @drivers.each do |driver|
        @spaces += driver.number_passengers
				@riders_done+=driver.current_passengers_number
      end
      @latitude_avg=0
      @longitude_avg=0
      count=0
      @locations=Hash.new;
      @drivers.each do |driver|
        location=driver.latitude.to_s+" "+driver.longitude.to_s
        if !@locations.has_key?(location)
          @locations[location]={:latitude => driver.latitude, :longitude => driver.longitude, :rides => Array.new}
        end
        if (driver.latitude && driver.latitude != 0 && driver.longitude && driver.longitude != 0)
          @latitude_avg+=driver.latitude
          @longitude_avg+=driver.longitude
          count+=1
        end
        @locations[location][:rides].push({:type => "driver",:id => driver.id})
      end
      @riders.each do |rider|
        location=rider.latitude.to_s+" "+rider.longitude.to_s
        if !@locations.has_key?(location)
          @locations[location]={:latitude => rider.latitude, :longitude => rider.longitude, :rides => Array.new}
        end
        if (rider.latitude != 0 && rider.longitude != 0)
          @latitude_avg+=rider.latitude
          @longitude_avg+=rider.longitude
          count+=1
        end
        @locations[location][:rides].push({:type => "rider",:id => rider.id})
      end
      if count != 0
        @latitude_avg/=count
        @longitude_avg/=count
      else
        @latitude_avg=0
        @longitude_avg=0
      end
      @message =false
      @help_rides = Ride.where(:latitude => 0, :longitude => 0, :event_id => current_event.id).includes(:person)
      @message = true if @help_rides.size > 0
    end
  end

  def login
    redirect_to event_path(params[:id])
  end

end
