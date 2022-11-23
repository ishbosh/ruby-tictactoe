# frozen_string_literal: true

# Displays the Text for the tic tac toe module
module DisplayText
  def show_intro
    "\n      -----------------------" \
      "\n      Welcome to Tic-Tac-Toe!" \
      "\n      -----------------------"
  end

  def show_name_prompt
    'Choose a name: '
  end

  def show_mark_prompt(player)
    "\n#{player.name}, choose a symbol to mark the board with." \
      "\nYour mark can be a letter, number, or special-character:  "
  end

  def show_turn(player)
    "#{player.mark} - #{player.name}'s turn: "
  end

  def show_first_turn_prompt(players)
    "\nEnter the mark or name of the player who will go first: " \
      "#{players[0].mark} or #{players[1].mark} "
  end

  def show_first_turn(player)
    "#{player} will go first." +
      show_separator
  end

  def show_how_to_play
    "\nHow To Play:\n  Requires two players." \
      " \n  Type move location as row-column" \
      "\n\nValid Moves:\n   top-left , top-mid , top-right" \
      "\n   mid-left ,   mid   , mid-right" \
      "\n   bot-left , bot-mid , bot-right\n " +
      show_separator
  end

  def show_input_error
    "Invalid move. Try again. Type 'help' to see how to play.\n "
  end

  def show_mark_error
    "\nInvalid mark choice. Must be 1 character, different from other player." \
      "\n Choose symbol to mark the board with:  "
  end

  def show_turn_prompt_error
    'Invalid name or mark. Enter name or mark of player who will go first.'
  end

  def show_victory(player)
    "#{player.mark} WINS! Great job #{player.name}!"
  end

  def show_tie
    "Cat's game! No winner!"
  end

  def show_restart_prompt
    'Game over. Play again? Type Y to restart or N to exit: '
  end

  def show_separator
    '      _______________________' \
      "\n "
  end

  def col_divider
    '---+---+---'
  end

  def row_divider
    '|'
  end
end
