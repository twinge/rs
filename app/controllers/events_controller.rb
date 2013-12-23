class EventsController < ApplicationController

  def show
    current_event = Event.find(params[:id])
    if current_event.nil?
		  render :text => 'No registrants from your conference have registered with Rideshare yet.' and return
    else
      @drivers = current_event.rides.drivers
      @riders = current_event.rides.passengers
      @hidden_rides = current_event.rides.hidden_drivers

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

      # find the avg lat/long
      @latitude_avg=0
      @longitude_avg=0
      count=0
      @locations=Hash.new;
      current_event.rides.each do |ride|
        location=ride.latitude.to_s+" "+ride.longitude.to_s
        if !@locations.has_key?(location)
          @locations[location]={:latitude => ride.latitude, :longitude => ride.longitude, :rides => Array.new}
        end
        if (ride.latitude && ride.latitude != 0 && ride.longitude && ride.longitude != 0)
          @latitude_avg+=ride.latitude
          @longitude_avg+=ride.longitude
          count+=1
        end
        type = ride.drive_willingness == 0 ? "rider" : "driver"
        @locations[location][:rides].push({:type => type,:id => ride.id})
      end
      if count != 0
        @latitude_avg/=count
        @longitude_avg/=count
      else
        @latitude_avg=0
        @longitude_avg=0
      end

      @help_rides = Ride.where(:latitude => 0, :longitude => 0, :event_id => current_event.id).includes(:person)
      @message = (@help_rides.size > 0)
    end
  end

  def login
    event = Event.where(conference_id: params[:id]).first
    redirect_to event
  end

  def email
    @event = Event.find(params[:id])
  end

  def submit_email
    @event = Event.find(params[:id])
    @drivers = @event.rides.active_drivers

    @event.email_content = params[:content]
    @event.save!

    @event.email_content = @event.email_content.gsub("\n", '<br />') if !@event.email_content.nil?

    @drivers.each do |driver|
      Email.car(driver.id).deliver
    end
    @notice = 'Emails successfully sent.'
  end

end
