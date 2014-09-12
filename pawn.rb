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
   if (@board.on_board?(move) && @board[move].nil?)
     moves << [pos[0], pos[1] + (2 * dy)]
   end 

    moves.select { |move| (@board.on_board?(move) && @board[move].nil?) }
  end

  def captures
    deltas = (color == :white ?  [[1,1], [-1,1]] : [[1,-1], [-1,-1]])
    captures = []

    deltas.each do |dx, dy|
      captures << [@pos[0] + dx, @pos[1] + dy] 
    end

    captures.select do |capture| {
      @board[capture] && @board[capture].color != color
    }
  end

end