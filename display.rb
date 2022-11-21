module DisplayText
  def show_intro
    'Welcome to Tic-Tac-Toe!'
  end

  def show_name_prompt
    #choose player name
  end

  def show_mark_prompt
    #choose player mark
  end

  def show_turn(player)
    "Player #{player.number} (#{player.mark}) turn: "
  end

  def show_first_turn_prompt
    'Enter the symbol for the player who will go first: '
  end

  def show_how_to_play
    "How To Play: Type move location as row-col"
    "\nExamples: top-left , mid-right , bot-mid , mid-mid"
  end

  def show_input_error
    'Invalid move. Try again. Type '
  end

  def show_victory(player)
    "#{player.mark} WINS! Great job #{player.number}!"
  end

  def show_tie
    "Cat's game!"
  end

  def show_restart_prompt
    'Game over. Play again? Type Y or N : '
  end

  def show_separator
    '___________'
  end

  def col_divider
    '---+---+---'
  end

  def row_divider
    '|'
  end
end