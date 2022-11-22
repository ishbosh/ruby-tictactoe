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
      game_setup
    end

    private

    def restart!
      @board = Board.new
      players.each {|player| player.turn = false}
      play
    end

    def game_setup
      intro_text
      player_setup
      play
    end

    def play
      @current_player = nil
      @winner = false

      decide_first_turn
      game_loop
      results
      restart?
    end

    def intro_text
      puts show_intro()
      sleep(1)
      puts show_how_to_play()
      puts show_separator()
    end

    def player_setup
      players.each_with_index do |player, i|
        sleep(0.5)
        print "\nPlayer #{i+1} - "
        print show_name_prompt()
        player.name = gets.chomp.capitalize
        sleep(0.5)
        print show_mark_prompt(player)
        player.mark = player_mark_setup()
        puts show_separator()
      end
    end

    def player_mark_setup
      valid_input = false
      until valid_input
        input = gets.chomp.upcase
        if input.match?(/^[^\s]$/) && input != players[0].mark
          valid_input = true
        else
          print show_mark_error()
        end
      end
      input
    end

    def results
      board.show() # Show final board.
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
        board.show()
        self.current_player = (players.select {|player| player.turn?}).first
        player_turn = current_player.take_turn(board)
        puts show_separator()
        board.update_display(current_player, player_turn)
        @winner = board.winner?(current_player)
        tie = board.full?
        players.each {|player| player.change_turn}
      end
    end

    def decide_first_turn
      first_player = nil
      choices = [players[0].mark, players[1].mark, 
                 players[0].name, players[1].name]
      until choices.include?(first_player)
        puts show_first_turn_prompt(players)
        first_player = gets.chomp.downcase.capitalize
      end
      puts "#{first_player} will go first."
      puts show_separator()
      players.each do |player|
        if [player.mark, player.name].include?(first_player)
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
                   [1,4,7], [2,5,8], [0,4,8], [2,4,6]].freeze

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

    def update_display(player, selection_keys)
      row_index, col_index = convert_to_index(selection_keys)
      @board[row_index][col_index] = " #{player.mark} "
    end

    def valid_move?(input)
      unless input.include?('-')
        return false
      end
      keys = convert_to_keys(input)
      row_index, col_index = convert_to_index(keys)
      if MOVE_INDEX_HASH.include?(keys[0]) && MOVE_INDEX_HASH.include?(keys[1])
        if @board[row_index][col_index] == '   '
          return true
        end
      else
        return false
      end
    end

    def winner?(current_player)
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

    def convert_to_index(keys)
      row_key = keys[0]
      col_key = keys[1]
      row_index = MOVE_INDEX_HASH[row_key]
      col_index = MOVE_INDEX_HASH[col_key]
        return row_index, col_index
    end

    def convert_to_keys(input)
      array = input.split('-')
      keys = [array[0].to_sym, array[1].to_sym]
      keys
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

    def turn?
      turn
    end

    def change_turn
      self.turn? ? self.turn = false : self.turn = true
    end

    def take_turn(board)
      valid = false
      until valid
        print show_turn(self)
        input = gets.chomp.downcase
        if input == 'help' || input == "'help'"
          puts show_how_to_play()
          puts show_separator()
          puts board.show
          next
        end

        input = 'mid-mid' if input == 'mid'
        valid = board.valid_move?(input)
        unless valid then puts show_input_error end
      end
      puts ''
      convert_to_keys(input)
    end

    private

    def convert_to_keys(input)
      array = input.split('-')
      [array[0].to_sym, array[1].to_sym]
    end
  end

  Game.new
end
