class Game
  attr_reader :player1, :player2, :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new('X')
    @player2 = Player.new('O')
    @turn = [nil, "Player 1 (X)", "Player 2 (O)"]
    Game.start()
  end

  private

  def start
    tie = false
    player = 1
    rules() #prints the game rules to the console
    until player1.victory || player2.victory || tie
      print(board)
      space = input(turn[player])
      update(player, space)
      player = player == 1 ? 2 : 1
    end
    print(board)
    winner = player1.victory ? "Player 1" : "Player 2" # fix this
    puts("#{winner} wins the game!")
  end

  def input(player)
    print "#{player} turn. Select a space: "

    space = gets.chomp
    space
    # ask the player for input
    # check validation of the input 
    # if valid, update the input, otherwise, ask again
  end

  def update(player, space)
    #update the board 
    if self.board.update(player, space) == "invalid"
      puts("That space is already taken!")
      space = input(player)
      update(player, space)
    end
  end

  def print(board)
    print(board.row1)
    print("\n#{board.divider}")
    print(board.row2)
    print("\n#{board.divider}")
    print(board.row3)
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
  attr_reader :divider, :board, :row1, :row2, :row3

  def initiallize
    @board = build()
  end

  protected

  def build
    @row1 = ['   ', '|', '   ','|','   ']
    @row2 = ['   ', '|', '   ','|','   ']
    @row3 = ['   ', '|', '   ','|','   ']
    @divider = '-----------'
    return row1, row2, row3, divider
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
  def initialize(mark)
    @mark = mark
    @victory = false
  end
  # should player class hold the turn as a class variable??
end

tic_tac_toe = Game.new
