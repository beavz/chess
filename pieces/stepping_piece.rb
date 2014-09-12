class SteppingPiece < Piece

  def moves
    moves = []

    deltas.each do |dx, dy|
      new_pos = [@pos[0] + dx, @pos[1] + dy]
      moves << new_pos
    end

    moves.select do |new_pos| 
      @board.on_board?(new_pos) && 
      (@board[new_pos].nil? || @board[new_pos].color != @color) 
    end
  end
end



