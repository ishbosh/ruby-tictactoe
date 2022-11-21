require_relative 'display.rb'

module TicTacToe
  class Game
    include DisplayText

    attr_reader :player1, :player2, :board, :players
    
    def initialize
      @board = Board.new
      @player1 = Player.new('X', 1)
      @player2 = Player.new('O', 2)
      @players = [player1, player2]
      play()
    end

    private

    def restart
      @board = Board.new
      @player1.turn = false
      @player2.turn = false
      play()
    end

    def play
      puts show_intro()
      puts show_how_to_play()
      @winner = nil
      decide_first_turn()
      game_loop()
      board.show()
      if @winner == 'tie'
        puts "Cat's Game!"
      elsif @winner == 'X'
        puts 'Player 1 (X) wins!'
      elsif @winner == 'O'
        puts 'Player 2 (O) wins!'
      end
      restart = nil
      until restart == 'Y' || restart == 'N'
        print "Play again? (Y/N) "
        restart = gets.chomp
        puts ''
      end
      restart() if restart == 'Y'
    end

    def game_loop
      tie = false
      until tie || @winner
        # update player to current player
        player = player1.turn? ? player1 : player2
        #print the board
        board.show()
        #ask the player to take their turn
        selection_keys = player.take_turn(board)
        #ask the board for an update
        board.update_display(player, selection_keys)
        #check for winner or tie
        @winner = check_for_winner()
        if @winner == 'tie' then tie = true end
        # change the turns (called on both players to swap each one's turn value)
        player1.change_turn
        player2.change_turn
      end
    end

    def check_for_winner
      row_keys = [:top, :mid, :bot]
      row_grid = row_keys.map do |row|
        board.moves[row].map {|k, v| v}
      end
      # convert rows to clumns
      col_grid = row_grid.transpose

      #check rows for winner
      winner = count_marks(row_grid)
      if winner then return winner end
      #check columns for winner
      winner = count_marks(col_grid)
      if winner then return winner end
      #check diagonals for winner
      winner = count_diagonals()
      if winner then return winner end
      unless row_grid.flatten.include?(nil)
        return 'tie'
      end
    end

    def count_marks(grid)
      winner = nil
      x_count = grid.map {|row| row.count('X')}
      o_count = grid.map {|row| row.count('O')}

      results = {X: x_count, O: o_count}
      results.each do |mark, counts|
        counts.each do |count|
          if count == 3
            winner = mark.to_s
          end
        end
        winner
      end
      winner
    end

    def count_diagonals
      tl_to_br = 
        [
          board.moves[:top][:left], 
          board.moves[:mid][:mid], 
          board.moves[:bot][:right]
        ]
      bl_to_tr = 
        [
          board.moves[:bot][:left],
          board.moves[:mid][:mid],
          board.moves[:bot][:right]
        ]
      x_count = [tl_to_br.count('X'), bl_to_tr.count('X')]
      o_count = [tl_to_br.count('O'), bl_to_tr.count('O')]
      if x_count[0] == 3 || x_count[1] == 3
        return 'X'
      elsif o_count[0] == 3 || o_count[1] == 3
        return 'O'
      end
    end

    def decide_first_turn
      first_player = nil
      until first_player == player1.mark || first_player == player2.mark
        puts show_first_turn_prompt()
        first_player = gets.chomp.upcase
      end
      puts show_separator()
      puts ''
      players.each do |player|
        if first_player == player.mark
        player.change_turn
        end
      end
    end

    public

  end

  class Board
    include DisplayText
    attr_reader :board

    WIN_INDEXES = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],
                   [1,4,8], [2,5,8], [0,4,8], [2,4,6]].freeze

    MOVE_INDEX_HASH = {top: 0, mid: 1, bot: 2, left: 0, mid: 1, right: 2}.freeze

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
      keys = input.split('-')
      keys[0] = keys[0].to_sym #eg.  :top
      keys[1] = keys[1].to_sym #eg.  :left
      if MOVE_INDEX_HASH.include?(keys[0]) && MOVE_INDEX_HASH.include?(keys[1])
        if board[MOVE_INDEX_HASH[keys[0]]][MOVE_INDEX_HASH[keys[1]]] == '  '
          return true
        end
      else
        return false
      end
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

    def update_display(player, selection_keys)
      # Get the indexes of the selection. Row then Col
      index_array = convert_to_index(selection_keys)
      row_index = index_array[0]
      col_index = index_array[1]
      @board[row_index][col_index] = " #{player.mark} "
    end
    
  end

  class Player
    include DisplayText

    attr_reader :mark, :number
    attr_accessor :turn

    def initialize(mark, number)
      @mark = mark
      @number = number
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

    def convert_to_keys(validated_input)
      # convert the input to the key equivalent
      array = validated_input.split('-')
      keys = [array[0].to_sym, array[1].to_sym]
      keys
    end

  end
end



include TicTacToe
Game.new
