module Hotel
  class Admin
    #Wave 1
    attr_reader :rooms, :reservations, :block_reservations

    def initialize
      # As an administrator, I can access the list of all of the rooms in the hotel
      @rooms = Hotel::Room.all # {ID : RoomObject}
      @reservations = [] # key: reservation, value: hash
      @block_reservations = []
    end

    # As an administrator, I can reserve an available room for a given date range
    def reserve(check_in, check_out, room_num)
      # Create a Reservation with those dates + assign a room
      raise InvalidObjectPassedError.new("Room number passed is invalid.") if room_num > NUM_OF_ROOMS || room_num < 0

      #TODO: REDUNDANT WITH BOTTOM FUNCTION
      @block_reservations.each do |other_block_reservation|
        other_block_reservation_room_numbers = other_block_reservation.rooms.map{|room| room.room_number}
        if other_block_reservation.overlap?(check_in, check_out) && other_block_reservation_room_numbers.include?(room_num) # the last conditional means if Array1 & Array2 have elements in common
          raise ArgumentError.new("There's overlap with this block reservation and an existing block reservation's date")
        end
      end

      #Check all reservations if it can be made
      @reservations.each do |reservation|
        if reservation.room.room_number == room_num && reservation.overlap?(check_in, check_out)
          raise DateOverlapError.new("There's overlap with this reservation and an existing reservation's date and room number")
        end
      end

      associated_room = find_room(room_num)
      new_reservation = Hotel::Reservation.new(check_in, check_out, associated_room)
      @reservations << new_reservation
      new_reservation.room.set_booked_dates(self)
      return new_reservation
    end

    # As an administrator, I can access the list of reservations for a specific date
    def reservations_at_date(date)
      # returns an array of reservations that have the given date in their range
      list_of_reservations_at_date = @reservations.select do |reservation|
        reservation.check_in <= date && reservation.check_out > date
      end
      return list_of_reservations_at_date
    end

    # returns a Room object if it finds it, nil otherwise
    def find_room(room_number)
      return @rooms.detect { |r| r.room_number == room_number}
    end

    # As an administrator, I can view a list of rooms that are not reserved for a given date range
    def available_rooms_in_date_range(date1, date2)
      raise InvalidObjectPassedError.new() if date1.class != Date || date2.class != Date
      raise DateOverlapError.new() if date2 < date1

      available_rooms = []

      @rooms.each do |room|
        available = true
        (date1..date2).each do |check_date|
          if !room.available_at?(check_date)
            available = false
          end
        end
        if available
          available_rooms << room
        end
      end
      return available_rooms
    end

    #takes check_in date, check_out date, and an Array of room numbers (Integers)
    def create_block(check_in, check_out, room_numbers)
      raise InvalidObjectPassedError.new() if check_in.class != Date || check_out.class != Date || room_numbers.length <= 0
      raise InvalidObjectPassedError.new() if room_numbers.class != Array && room_numbers[0].class != Integer

      # Compare with block reservations to see if some overlap..
      @block_reservations.each do |other_block_reservation|
        other_block_reservation_room_numbers = other_block_reservation.rooms.map{|room| room.room_number}
        if other_block_reservation.overlap?(check_in, check_out) && ((other_block_reservation_room_numbers & room_numbers).length > 0) # the last conditional means if Array1 & Array2 have elements in common
          raise DateOverlapError.new()
        end
      end

      # Compare with single reservations if they overlap...
      @reservations.each do |reservation|
        if reservation.overlap?(check_in, check_out) && room_numbers.include?(reservation.room.room_number)
          raise DateOverlapError.new()
        end
      end

      # Create a Hotel::BlockReservation.new
      generated_rooms = room_numbers.map do |room_number|
        find_room(room_number)
      end
      # TODO: Move this to when you're booking a room within a block
      # generated_rooms.each do |room|
      #   room.set_booked_dates(self)
      # end
      new_block = Hotel::BlockReservation.new(check_in, check_out, generated_rooms)
      @block_reservations << new_block
      return new_block
    end

    # def reserve_in_block(block_reservation, room_num)
    #   room = find_room(room_num)
    #   if !block_reserve.rooms.include?(room)
    #     raise ArgumentError.new("Room Number #{room_num} is not in the given block reservations")
    #   end
    #
    #   #
    # end

  end
end
