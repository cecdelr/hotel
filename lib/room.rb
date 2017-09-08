require 'date'

module Hotel

  NUM_OF_ROOMS = 20

  class Room
    attr_reader :available, :cost, :room_number

    def initialize(room_number)
      @available = true
      # @blocked_off = false #for Wave 3
      @cost = 200
      @room_number = room_number
    end

    def change_availability(state) # T or F
      # @available ? @available = false : @available = true
      @available = state
    end

    def self.all
      room_array = []
      NUM_OF_ROOMS.times do |i|
        room_array << Hotel::Room.new(i + 1) # Hotel Room Numbers start with 1, not 0
      end
      return room_array
    end

  end # END OF CLASS

end # END OF MODULE
