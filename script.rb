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
      #print the board
      board()
      #ask the player to take their turn
      
      #ask the board for an update
      #check for winner or tie
      # change the turn

    end
    # when there is a winner or tie
    # print the final board
    # if its a tie, declare a cat's game
    # otherwise, declare the winner
    # ask if they would like to play again
    print(board)

  end

  # def input(player)
  #   print "#{player} turn. Select a space: "

  #   space = gets.chomp
  #   space
  #   # ask the player for input
  #   # check validation of the input 
  #   # if valid, update the input, otherwise, ask again
  # end

  # def update(player, space)
  #   #update the board 
  #   if self.board.update(player, space) == "invalid"
  #     puts("That space is already taken!")
  #     space = input(player)
  #     update(player, space)
  #   end
  # end

  def board()
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

  protected

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

  def update(player, space)
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
    selection = input(board)
    selection
  end

  private

  # get player input for the board
  def input(board)
    valid = false
    until valid
      input = gets.chomp
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