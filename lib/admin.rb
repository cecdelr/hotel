require 'pry'
module Hotel
  class Admin
    #Wave 1
    attr_reader :rooms, :reservations

    def initialize
      # As an administrator, I can access the list of all of the rooms in the hotel
      @rooms = Hotel::Room.all # {ID : RoomObject}
      @reservations = [] # key: reservation, value: hash
    end

    # As an administrator, I can reserve a room for a given date range
    def reserve(check_in, check_out, room_num)
      # Create a Reservation with those dates + assign a room
      raise ArgumentError.new("Passed in invalid dates.") if check_out <= check_in
      raise ArgumentError.new("Room number passed is invalid.") if room_num > NUM_OF_ROOMS || room_num < 0

      #Check all reservations if it can be made
      @reservations.each do |reservation|
        if reservation.check_in <= check_in || reservation.check_out >= check_out
          raise ArgumentError.new("There's overlap with this reservation and an existing reservation")
        end
      end

      associated_room = find_room(room_num)
      new_reservation = Hotel::Reservation.new(check_in, check_out, associated_room)
      @reservations << new_reservation
      return new_reservation
    end

    # As an administrator, I can access the list of reservations for a specific date
    def reservations_at_date(date)
      # takes in a date
      # returns an array of reservations that have the date in their range
            # date >= check_in_date < check_out_date
    end

    # As an administrator, I can get the total cost for a given reservation
    def total_cost(reservation)
      # Get how many days a customer is staying (check_out - check_in)
      # Multiply by room cost
      # return
    end

    #find a Room object that's available
    def find_room(room_num)
      return @rooms.detect { |r| r.available == true }
    end


  end
end
