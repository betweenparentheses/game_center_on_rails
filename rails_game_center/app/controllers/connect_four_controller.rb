class ConnectFourController < ApplicationController

  NUM_COLS = 7
  NUM_ROWS = 6
  WIN_COUNT =4

  def new
    init_session_variables
    redirect_to connect_four_play_turn_path

  end

  def play_turn

    #main board and submissions form.
    #like an EDIT
    load_session_variables


  end

  def show
    #game ending, no submissions allowed
  end

  def drop_piece
    #handles POSTS from move form
    @col_selection = params[:column].to_i  # col num that was selected on the form
    load_session_variables # to send to model
    @connect_four_game_instance = ConnectFour.new(@board_arr, @curr_player)

    @connect_four_game_instance.accept_piece(@col_selection, @curr_player["play_piece"])

   #redirects to show if game over
    if check_game_over
      redirect_to connect_four_show_path
    else
     #redirects to play_turn if game ongoing
     redirect_to connect_four_play_turn_path
    end

  end

  private

  def init_session_variables
    @board_arr = Array.new(NUM_COLS) { Array.new(NUM_ROWS){ "_" } }
    session[:board] = @board_arr

    @player1 = {type: "human" , play_piece: "X"}
    session[:player1] = @player1
    @player2 = {type: "AI", play_piece: "O"}
    session[:player2] = @player2
    @curr_player = @player1
    session[:@curr_player] = @curr_player

  end

  def load_session_variables
    @num_cols = NUM_COLS
    @num_rows = NUM_ROWS

    @board_arr = session[:board]
    @player1 = session[:player1]
    @player2 = session[:player2]
    @curr_player = session[:@curr_player]
  end

    def check_game_over
      check_victory || check_draw
    end

    def check_victory
      if winning_combination?
        true
      else
        false
      end
    end

    def check_draw
      if @board_arr.all? do |col|
          col.none?{|cell| cell=="_"}
        end
        # puts "The gameboard is full, it's a draw."
        true
      else
        false
      end
    end

    def winning_combination?
      winning_diagonal?   ||
      winning_horizontal? ||
      winning_vertical?
    end

    def winning_diagonal?
      # check if are four in a row on any verticals
      return @connect_four_game_instance.diag_pieces_in_a_row?(WIN_COUNT, @curr_player["play_piece"])
    end

    def winning_vertical?
      # check if are four in a row on any verticals
      return @connect_four_game_instance.vert_pieces_in_a_row?(WIN_COUNT, @curr_player["play_piece"])
    end

    def winning_horizontal?
      # check if are four in a row on any horizontals
      return @connect_four_game_instance.horz_pieces_in_a_row?(WIN_COUNT, @curr_player["play_piece"])
    end

end
