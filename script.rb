class Game
  attr_reader :player1, :player2, :board
  
  def initialize
    @board = Board.new
    @player1 = Player.new('X')
    @player2 = Player.new('O')
  end

  def start
    @turn = player1
    tie = false
    # choose player to go first, track last player went
    until player1.victory || player2.victory || tie
      
    end
    # until winner is declared, ask for input from other player
    # then validate the input
    # then update the game state
    #  then print the updated state to console
  end

  def input(player)
    # ask the player for input
    # check validation of the input 
    # if valid, update the input, otherwise, ask again
  end

  def update(player, space)
    #update the board
    self.board.update(player, space)
  end

  def print(board)
    print(board.row1)
    print("\n#{board.divider}")
    print(board.row2)
    print("\n#{board.divider}")
    print(board.row3)
  end

end

class Board
  attr_reader :divider, :board, :row1, :row2, :row3

  def initiallize
    @board = build()
  end

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
      self.row1[0] = mark
    when 2
      self.row1[2] = mark
    when 3
      self.row1[4] = mark
    when 4
      self.row2[0] = mark
    when 5
      self.row2[2] = mark
    when 6
      self.row2[4] = mark
    when 7
      self.row3[0] = mark
    when 8
      self.row3[2] = mark
    when 9
      self.row3[4] = mark
    end
  end
end

class Player
  def initialize(mark)
    @mark = mark
    @victory = false
  end
end

tic_tac_toe = Game.new
