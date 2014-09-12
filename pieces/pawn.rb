require_relative 'piece'

class Pawn < Piece

  def display
    color == :white ? "♙" : "♟"
  end

  def power
    5
  end

  def moves
    moves_to_empty + captures
  end

  private

  def moves_to_empty
    home_row = ( color == :white ? 1 : 6 )
    dy = ( color == :white ? 1 : -1 )
    
    #regular move
    moves = [[pos[0], pos[1] + dy]] 
    #optional for first move only
    move = [pos[0], pos[1] + (2 * dy)]
    moves << move if (@board.on_board?(move) && @board[move].nil?)

    moves.select { |move| (@board.on_board?(move) && @board[move].nil?) }
  end

  def captures
    deltas = (color == :white ?  [[1,1], [-1,1]] : [[1,-1], [-1,-1]])
    captures = []

    deltas.each do |dx, dy|
      capture = [pos[0] + dx, pos[1] + dy] 
      if (@board.on_board?(capture) && !@board[capture].nil? && @board[capture].color != color)
        captures << capture
      end
    end
    
    captures
  end

end