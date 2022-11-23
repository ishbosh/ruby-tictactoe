# frozen_string_literal: true

require_relative 'display'

# Tic Tac Toe Game
module TicTacToe
  ## GAME ##
  class Game
    include DisplayText

    attr_reader :board
    attr_accessor :players

    def initialize
      @board = Board.new
      @players = [Player.new, Player.new]
      @current_player_index = 0
      game_setup
    end

    private

    def restart!
      @board = Board.new
      @current_player_index = 0
      play
    end

    def game_setup
      intro_text
      player_setup
      play
    end

    def play
      @current_player = nil
      @winner = false

      puts show_first_turn_prompt(players)
      decide_first_turn
      show_first_turn(current_player)
      game_loop
      results
      restart?
    end

    def intro_text
      puts show_intro
      sleep(1)
      puts show_how_to_play
    end

    def player_setup
      players.each_with_index do |player, i|
        sleep(0.5)
        print "\nPlayer #{i + 1} - "
        print show_name_prompt
        player.name = gets.chomp.downcase.capitalize
        print show_mark_prompt(player)
        player.mark = player_mark_setup
      end
    end

    def player_mark_setup
      valid_input = false
      until valid_input
        input = gets.chomp.upcase
        if input.match?(/^[^\s]$/) && input != players[0].mark
          valid_input = true
        else
          print show_mark_error
        end
      end
      input
    end

    def results
      board.show # Show final board.
      if board.winner?(current_player)
        puts show_victory(current_player)
      else
        puts show_tie
      end
    end

    def restart?
      positive_answers = %w[Y YES RESTART]
      puts show_restart_prompt
      answer = gets.chomp
      restart! if positive_answers.include?(answer.upcase)
    end

    def game_loop
      loop do
        board.show
        player_input = current_player.take_turn(board)
        board.update_display(current_player, player_input)
        break if board.full? || board.winner?(current_player)

        next_player_turn
      end
    end

    def current_player
      @players[@current_player_index]
    end

    def decide_first_turn
      first_turn = nil
      loop do
        first_turn = gets.chomp.downcase.capitalize
        break if player_info.include?(first_turn)

        puts show_turn_prompt_error
      end
      puts show_separator
      @current_player_index = 1 unless player_info[0..1].include?(first_turn)
    end

    def next_player_turn
      puts show_separator
      @current_player_index = (@current_player_index + 1) % @players.size
    end

    def player_info
      [players[0].mark, players[0].name, players[1].mark, players[1].name]
    end
  end

  ## BOARD ##
  class Board
    include DisplayText
    attr_reader :board

    WIN_LINES = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6],
      [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]
    ].freeze

    MOVE_INDEX_HASH = { top: 0, mid: 1, bot: 2, left: 0, right: 2 }.freeze

    def initialize
      @board = [
        ['   ', '   ', '   '],
        ['   ', '   ', '   '],
        ['   ', '   ', '   ']
      ]
    end

    def show
      print_conditions = [0, 1]
      board.each_with_index do |array, index|
        array.each_with_index do |grid_space, i|
          print grid_space
          print row_divider if print_conditions.include?(i)
        end
        puts ''
        puts col_divider if print_conditions.include?(index)
      end
      puts ''
    end

    def update_display(player, selection_keys)
      row_index, col_index = convert_to_index(selection_keys)
      @board[row_index][col_index] = " #{player.mark} "
    end

    def valid_move?(input)
      return false unless input.include?('-')

      keys = convert_to_keys(input)
      row_index, col_index = convert_to_index(keys)
      if MOVE_INDEX_HASH.include?(keys[0]) && MOVE_INDEX_HASH.include?(keys[1])
        true if @board[row_index][col_index] == '   '
      else
        false
      end
    end

    def winner?(current_player)
      flat_board = board.flatten
      WIN_LINES.any? do |line|
        [flat_board[line[0]],
         flat_board[line[1]],
         flat_board[line[2]]].uniq.eql?([" #{current_player.mark} "])
      end
    end

    def full?
      open_space = board.flatten.select { |grid_space| grid_space == '   ' }
      open_space.empty?
    end

    def convert_to_index(keys)
      row_key = keys[0]
      col_key = keys[1]
      row_index = MOVE_INDEX_HASH[row_key]
      col_index = MOVE_INDEX_HASH[col_key]
      [row_index, col_index]
    end

    def convert_to_keys(input)
      array = input.split('-')
      [array[0].to_sym, array[1].to_sym]
    end

    def help
      puts show_how_to_play
      puts show # show board
    end
  end

  ## PLAYER ##
  class Player
    include DisplayText

    attr_accessor :turn, :mark, :name

    def initialize
      @mark = nil
      @name = nil
    end

    def take_turn(board)
      loop do
        input = player_input
        if ['help', "'help'"].include?(input)
          board.help
          next
        end
        return board.convert_to_keys(input) if board.valid_move?(input)

        puts show_input_error
      end
    end

    private

    def player_input
      print show_turn(self)
      input = gets.chomp.downcase
      input = 'mid-mid' if input == 'mid'
      input
    end
  end

  Game.new
end
