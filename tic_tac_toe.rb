# frozen_string_literal: true

class Game
  WINNING_LANE_INDEX = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 8],
                        [0, 3, 6], [1, 4, 7], [2, 5, 8], [2, 4, 6]].freeze

  VALID_COORDINATES = {"A1" => 0, "A2" => 1, "A3" => 2,"B1" => 3, "B2" => 4, "B3" => 5, "C1" => 6, "C2" => 7, "C3" => 8}.freeze
  
  attr_accessor :player_placements
  def initialize
    @turn_number = 1
    @winning_lane = []
    @open_space =  {"A1" => true, "A2" => true, "A3" => true,"B1" => true, "B2" => true, 
      "B3" => true, "C1" => true, "C2" => true, "C3" => true}
    @player_placements = ['d', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l']
    @player_shape = {:player1 => "X", :player2 => "O"}
    @player_order = {:first => "Player 1", :second => "Player 2"}
    @player_score = {:player1 => 0, :player2 => 0}
    @game_continue = true
  end

  def intro
    puts "Welcome to Tic-Tac-Toe"
    gameloop
  end

  def switch_players
    temp = @player_shape[:player1]
    @player_shape[:player1] = @player_shape[:player2]
    @player_shape[:player2] = temp

    temp = @player_order[:first]
    @player_order[:first] = @player_order[:second]
    @player_order[:second] = temp
    
  end

  def gameloop
    puts "#{@player_order[:first]} vs #{@player_order[:second]}"
    puts "#{@player_shape[:player1]} vs #{@player_shape[:player2]}"
    while @game_continue
      display_map
      pick_square
      if check_win?
        display_map
        update_score
        try_again?
      end
    end
    if @player_score[:player1] > @player_score[:player2]
      puts "Game ended"
      puts "Player 1 Beats Player 2"
    elsif @player_score[:player1] < @player_score[:player2]
      puts "Game ended"
      puts "Player 2 Beats Player 1"
    else
      puts "Game ended in a tie"
    end
    puts "Good Game"
  end

  def update_score
    puts @winning_lane.uniq[0].inspect
    puts @player_shape[:player1]
    if @winning_lane.uniq[0] == @player_shape[:player1]
      puts "Player 1 wins"
      @player_score[:player1] = @player_score[:player1] + 1
    elsif @winning_lane.uniq[0] == @player_shape[:player2]
      puts "Player 2 wins"
      @player_score[:player2] = @player_score[:player2] + 1
    else 
      puts "Tie"
    end
  end

  def pick_square
    puts "Type the coordinate of where you want to play (Example A2): "
    loop do
      coordinate = gets.chomp
      if VALID_COORDINATES.has_key?(coordinate) && @open_space[coordinate]
        shape = get_shape
        place_square(coordinate, shape)
        break
      else
        puts "Invalid"
      end
    end
  end


  def try_again?
    puts "Do you want to play again? Type 'Yes' or 'No'."
    loop do
      player_decision = gets.chomp
      if player_decision.downcase == 'yes'
        @turn_number = 1
        @open_space =  {"A1" => true, "A2" => true, "A3" => true,"B1" => true, "B2" => true, 
          "B3" => true, "C1" => true, "C2" => true, "C3" => true}
        @player_placements = ['d', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l']
        switch_players
        @game_continue = true
        break
      elsif player_decision.downcase == 'no'
        @game_continue = false
        break
      else
        puts "Invalid Response"
      end
    end
  end
  
  def check_win?
    WINNING_LANE_INDEX.any? do |row|
      @winning_lane = [@player_placements[row[0]], @player_placements[row[1]], @player_placements[row[2]]]
      @winning_lane.uniq.length == 1
    end
  end

  def get_shape
    if @turn_number%2 == 1
      @turn_number += 1
      "X"
    else
      @turn_number += 1
      "O"
    end
  end

  def place_square(coordinate, shape)
    @open_space[coordinate] = false
    @player_placements[VALID_COORDINATES[coordinate]] = shape
  end

  def display_map
    puts "
                |       |
      A     #{@player_placements[0]}   |   #{@player_placements[1]}   |   #{@player_placements[2]}
         _______|_______|_______
                |       |
      B     #{@player_placements[3]}   |   #{@player_placements[4]}   |   #{@player_placements[5]}
         _______|_______|_______
                |       |
      C     #{@player_placements[6]}   |   #{@player_placements[7]}   |   #{@player_placements[8]}
                |       |
            1       2       3
    ".gsub(/[[:lower:]]/, " ")
  end
end
