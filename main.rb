require_relative 'display.rb'

module TicTacToe
  ## GAME ##
  class Game
    include DisplayText

    attr_reader :board
    attr_accessor :players, :current_player
    
    def initialize
      @board = Board.new
      @player1 = Player.new(nil, nil)
      @player2 = Player.new(nil, nil)
      @players = [@player1, @player2]
      play()
    end

    private

    def restart!
      @board = Board.new
      players.each {|player| player.turn = false}
      play()
    end

    def play
      @current_player = nil
      @winner = false

      intro_text()
      player_setup()
      decide_first_turn()
      game_loop()
      results()

      restart?()
    end

    def intro_text
      puts show_intro()
      puts show_how_to_play()
    end

    def player_setup
      players.each_with_index do |player, i|
        print "\nPlayer #{i+1} - "
        print show_name_prompt()
        player.name = gets.chomp
        print show_mark_prompt(player)
        player.mark = player_mark_setup()
      end
    end

    def player_mark_setup
      valid_input = false
      until valid_input
        input = gets.chomp
        if input == player[0].mark
          show_mark_error()
          show_mark_prompt()
        elsif 
          input.match?(/^[^0-9]$/)
          valid_input = true
        end
      end
      input
    end

    def results
      if @winner
        puts show_victory(current_player) 
      else
        puts show_tie()
      end
    end

    def restart?
      positive_answers = ['Y', 'YES', 'RESTART']
      restart = false
      puts show_restart_prompt()
      answer = gets.chomp
      restart!() if positive_answers.include?(answer.upcase)
    end

    def game_loop
      tie = false
      until tie || @winner
        current_player = players.select {|player| player.turn?}
        player_turn = current_player.take_turn(board)
        board.update_display(current_player, player_turn)
        @winner = board.winner?(current_player)
        tie = board.full?
        players.each {|player| player.change_turn}
        board.show()
      end
    end

    def decide_first_turn
      first_player = nil
      until first_player == player[0].mark || first_player == player[1].mark
        puts show_first_turn_prompt()
        first_player = gets.chomp.upcase
      end
      puts "#{first_player} will go first."
      puts show_separator()
      players.each do |player|
        if first_player == player.mark
        player.change_turn
        end
      end
    end

    public

  end

  ## BOARD ##
  class Board
    include DisplayText
    attr_reader :board

    WIN_LINES = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],
                   [1,4,8], [2,5,8], [0,4,8], [2,4,6]].freeze

    MOVE_INDEX_HASH = {top: 0, mid: 1, bot: 2, left: 0, right: 2}.freeze

    def initialize
      @board = 
      [ ['   ', '   ','   '], 
        ['   ', '   ','   '], 
        ['   ', '   ','   '] ] 
    end

    def show
      board.each_with_index do |array, index|
        array.each_with_index do |space, i|
          print space
          print row_divider() if i == 0 || i == 1
        end
        puts ''
        puts col_divider() if index == 0 || index == 1
      end
      puts ''
    end

    def valid_move?(input)
      unless input.include?('-')
        return false
      end
      keys = convert_to_keys(input)
      if MOVE_INDEX_HASH.include?(keys[0]) && MOVE_INDEX_HASH.include?(keys[1])
        if board[MOVE_INDEX_HASH[keys[0]]][MOVE_INDEX_HASH[keys[1]]] == '  '
          return true
        end
      else
        return false
      end
    end

    def win_move?(current_player)
      flat_board = board.flatten
      WIN_LINES.any? do |line|
        [flat_board[line[0]], 
         flat_board[line[1]], 
         flat_board[line[2]]].uniq.eql?([" #{current_player.mark} "])
      end
    end

    def full?
      open_space = board.flatten.select {|space| space == '   '}
      open_space.empty?
    end

    private

    def convert_to_index(selection_keys)
      # converts moves keys to display_array indexes
      row_key = selection_keys[0]
      col_key = selection_keys[1]
      
      row_index = move_hash[row_key]
      col_index = move_hash[col_key]
        return row_index, col_index
    end

    def convert_to_keys(input)
      array = input.split('-')
      keys = [array[0].to_sym, array[1].to_sym]
      keys
    end

    def update_display(player, selection_keys)
      # Get the indexes of the selection. Row then Col
      index_array = convert_to_index(selection_keys)
      row_index = index_array[0]
      col_index = index_array[1]
      @board[row_index][col_index] = " #{player.mark} "
    end
    
  end

  ## PLAYER ##
  class Player
    include DisplayText

    attr_accessor :turn, :mark, :name

    def initialize(mark, name)
      @mark = mark
      @name = name
      @turn = false
    end

    # ask player if it is their turn
    def turn?
      turn
    end

    # if it is this player's turn, switch turns
    def change_turn
      self.turn? ? self.turn = false : self.turn = true
    end

    def take_turn(board)
      # get the player's input
      valid = false
      until valid
        print show_turn(self)
        input = gets.chomp
        input = 'mid-mid' if input == 'mid'
        # validate player input
        valid = board.valid_move?(input)
        unless valid then puts show_input_error() end
      end
      puts ''
      selection_keys = convert_to_keys(input)
      selection_keys
    end

    private

    def convert_to_keys(input)
      array = input.split('-')
      keys = [array[0].to_sym, array[1].to_sym]
      keys
    end

  end
end



include TicTacToe
Game.new
