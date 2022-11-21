module DisplayText
  def show_intro
    'Welcome to Tic-Tac-Toe! Type into the console to play.'
  end

  def show_name_prompt
    #choose player name
  end

  def show_turn(player)
    "Player #{player.number} (#{player.mark}) turn: "
  end

  def show_how_to_play
    "Type move location as row-col \n
    Examples: top-left , mid-right , bot-mid , mid-mid"
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
end