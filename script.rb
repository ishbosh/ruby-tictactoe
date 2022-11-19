class Game
  attr_reader :player1, :player2, :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new('X', 1)
    @player2 = Player.new('O', 2)
    Game.start()
  end

  protected

  def start
    tie = false
    rules() #prints the game rules to the console
    until player1.victory || player2.victory || tie # fix this line
      # change the turn
      #
      # update player to current player
      player = player1.turn? ? player1 : player2
      #print the board
      show_board()
      #ask the player to take their turn
      selection_keys = player.take_turn(board)
      #ask the board for an update
      board.update(player, selection_keys)
      #check for winner or tie
      #
    end
    # when there is a winner or tie
    # print the final board
    # if its a tie, declare a cat's game
    # otherwise, declare the winner
    # ask if they would like to play again
    print(board)

  end

  def show_board()
    puts(board.row1.join)
    puts(board.divider)
    puts(board.row2.join)
    puts(board.divider)
    puts(board.row3.join)
  end

  public

  def rules
    #print the game rules to the console
    puts('Get 3 in a row. X goes first.')
    puts('Select space by number.') 
    puts('Top row is 1, 2, 3')
    puts('Middle row is 4, 5, 6')
    puts('Bottom row is 7, 8, 9')
    puts('')
  end

end

class Board
  attr_reader :divider, :board, :row1, :row2, :row3, :moves

  def initiallize
    @board = build()
  end

  def valid?(input)
    #check the moves hash for valid input and return whether it is valid
    # if the key is not found, also return invalid/false
  end

  def update(player, validated_input)
    #update_display
    update_display(player, validated_input)
    #update moves hash
    update_moves(player, validated_input)
  end

  private

  def build
    @row1 = ['   ', '|', '   ','|','   ']
    @row2 = ['   ', '|', '   ','|','   ']
    @row3 = ['   ', '|', '   ','|','   ']
    @divider = '-----------'
    @moves = 
      {
        top: {left: nil, mid: nil, right: nil}, 
        mid: {left: nil, mid: nil, right: nil},
        bot: {left: nil, mid: nil, right: nil}
      }
    return row1, row2, row3, divider, moves
  end

  def update_display(player, validated_input)
    player == 1 ? mark = ' X ' : mark = ' O '
    case space
    when 1
      self.row1[0] == '   ' ? self.row1[0] = mark : return "invalid"
    when 2
      self.row1[2] == '   ' ? self.row1[2] = mark : return "invalid"
    when 3
      self.row1[4] == '   ' ? self.row1[4] = mark : return "invalid"
    when 4
      self.row2[0] == '   ' ? self.row2[0] = mark : return "invalid"
    when 5
      self.row2[2] == '   ' ? self.row2[2] = mark : return "invalid"
    when 6
      self.row2[4] == '   ' ? self.row2[4] = mark : return "invalid"
    when 7
      self.row3[0] == '   ' ? self.row3[0] = mark : return "invalid"
    when 8
      self.row3[2] == '   ' ? self.row3[2] = mark : return "invalid"
    when 9
      self.row3[4] == '   ' ? self.row3[4] = mark : return "invalid"
    end
  end

  def update_moves(player, validated_input)
    # update the moves hash with the new input

    # moves[row][col] = player's mark
  end

  
end

class Player
  attr_reader :type, :number
  attr_accessor :turn

  def initialize(type, number)
    @type = type
    @number = number
    @turn = false
  end

  # ask player if it is their turn
  def turn?
    turn
  end

  # if it is this player's turn, switch turns
  def change_turn(player)
    player.turn? ? player.turn = false : player.turn = true
  end

  def take_turn(board)
    # ask for player input
    print "Player #{number} turn: "
    # get the player's input
    validated_input = input(board)
    selection_keys = convert_to_keys(validated_input)
    selection_keys
  end

  private

  def convert_to_keys(validated_input)
    # convert the input to the key equivalent
    array = validated_input.split('-')
    keys = [array[0].to_sym, array[1].to_sym]
    keys
  end

  def input(board)
    valid = false
    until valid
      # get player input for the board
      input = gets.chomp
      # validate player input
      valid = board.valid?(input)
    end
    input
  end
  # should player class hold the turn as a class variable??
  # player makes the turn decision
end

tic_tac_toe = Game.new


## Problems I need to address:
## How do I determine the winner? 
## How do I determine if there is a tie?
## Classes are starting to get muddled
## ideas:
## Separate the board display from the internal game 
## ie. have a separate array that is tracking player moves
## this array is the one that determines winner
## iterate through the 3 rows looking for 3 in a row
## iterate through the 3 columns looking for 3 in a row
## then check the top left, middle, and bottom right
## then check the top right, middle, and bottom left
## if there are no winners and the array is full then its a tie