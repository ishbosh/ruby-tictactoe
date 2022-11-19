class Game
  attr_reader :player1, :player2, :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new('X', 1)
    @player2 = Player.new('O', 2)
    start()
  end

  private

  def start
    @winner = nil
    #print the game rules to the console
    rules()
    # ask who will go first
    decide_first_turn()
    game_loop()
    # when there is a winner or tie
    # print the final board
    # if its a tie, declare a cat's game
    # otherwise, declare the winner
    # ask if they would like to play again
    show_board()

  end

  def game_loop
    tie = false
    until tie || @winner
      # update player to current player
      player = player1.turn? ? player1 : player2
      #print the board
      show_board()
      #ask the player to take their turn
      selection_keys = player.take_turn(board)
      #ask the board for an update
      board.update(player, selection_keys)
      #check for winner or tie
      @winner = check_for_winner()
      if @winner == 'tie' then tie = true end
      # change the turns (called on both players to swap each one's turn value)
      player1.change_turn
      player2.change_turn
    end
  end

  def show_board
    board.display_array.each_with_index do |array, index|
      puts array.join
      if index == 0 || index == 1
        puts board.divider 
      end
    end
    puts ''
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
    player = nil
    until player == '1' || player == '2'
      puts "Which player will go first, 1 or 2?"
      print "Player: "
      player = gets.chomp
    end
    puts '___________'
    puts ''
    if player == '1'
      player1.change_turn
    elsif player == '2'
      player2.change_turn
    end
  end

  public

  def rules
    #print the game rules to the console
    puts('Get 3 in a row. X goes first.')
    puts('Select space by typing in the location.') 
    puts('Use a - to separate the words.')
    puts('Examples: ')
    puts('top-left  bot-right  mid-mid')
    puts('')
  end

end

class Board
  attr_reader :display_array, :divider, :moves

  def initialize
    @display_array, @divider, @moves = build()
  end

  def valid?(input)
    unless input.include?('-')
      return false
    end
    keys = input.split('-')
    keys[0] = keys[0].to_sym
    keys[1] = keys[1].to_sym
    if moves.include?(keys[0]) 
      if moves[keys[0]].include?(keys[1]) && moves[keys[0]][keys[1]] == nil
          return true
      end
    else
      return false
    end
  end

  def update(player, selection_keys)
    #update_display
    update_display(player, selection_keys)
    #update moves hash
    update_moves(player, selection_keys)
  end

  private

  def build
    # display_array & divider is what will be displayed on the board
    display_array = 
      [ #  0           2         4  <--Column indexes
        ['   ', '|', '   ','|','   '], # 0 
        ['   ', '|', '   ','|','   '], # 1
        ['   ', '|', '   ','|','   ']  # 2
      ]                                # ^-- Row indexes 
    divider = '-----------'
    # moves is the locations of each move
    moves = 
      {
        top: {left: nil, mid: nil, right: nil}, 
        mid: {left: nil, mid: nil, right: nil},
        bot: {left: nil, mid: nil, right: nil}
      }
    return display_array, divider, moves
  end

  def convert_to_index(selection_keys)
    # converts moves keys to display_array indexes
    row_key = selection_keys[0]
    col_key = selection_keys[1]
    row_index =
      case row_key
      when :top
        0
      when :mid
        1
      when :bot
        2
      end
    col_index =
      case col_key
      when :left
        0
      when :mid
        2
      when :right
        4
      end
      return row_index, col_index
  end

  def update_display(player, selection_keys)
    # Get the indexes of the selection. Row then Col
    index_array = convert_to_index(selection_keys)
    row_index = index_array[0]
    col_index = index_array[1]
    @display_array[row_index][col_index] = " #{player.mark} "
  end

  def update_moves(player, selection_keys)
    # update the moves hash with the new input
    row_key = selection_keys[0]
    col_key = selection_keys[1]
    @moves[row_key][col_key] = player.mark
    @moves
  end

  
end

class Player
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
      # ask for player input
      print "Player #{number} (#{mark}) turn: "
      # get player input for the board
      input = gets.chomp
      # validate player input
      valid = board.valid?(input)
      unless valid then puts 'Invalid move.' end
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

tic_tac_toe = Game.new