module DisplayText
  def show_intro
    "\n------------------------"+
    "\n Welcome to Tic-Tac-Toe!"+
    "\n------------------------"
  end

  def show_name_prompt
    "Choose a name: "
  end

  def show_mark_prompt(player)
    "\n#{player.name}, choose a symbol to mark the board with." +
    "\n Your mark must be ONE character:  "
  end

  def show_turn(player)
    "#{player.mark} - #{player.name}'s turn: "
  end

  def show_first_turn_prompt(players)
    "Enter the mark of the player who will go first: " +
    "#{players[0].mark} or #{players[1].mark} "
  end

  def show_how_to_play
    "\nHow To Play: Type move location as row-col" + 
    "\nExamples: top-left , mid-right , bot-mid , mid-mid"
  end

  def show_input_error
    'Invalid move. Try again.'
  end

  def show_mark_error
    "\nInvalid mark choice. Must be 1 character, different from other player." +
    "\n Choose symbol to mark the board with:  "
  end

  def show_victory(player)
    "#{player.mark} WINS! Great job #{player.number}!"
  end

  def show_tie
    "Cat's game!"
  end

  def show_restart_prompt
    'Game over. Play again? Type Y to restart or N to exit: '
  end

  def show_separator
    '______________________'
    "\n"
  end

  def col_divider
    '---+---+---'
  end

  def row_divider
    '|'
  end
end