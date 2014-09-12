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

class Knight < SteppingPiece

  def display
    color == :white ? "♘" : "♞"
  end

  def power
    4
  end

  private

  def deltas
    [[2, 1],[2, -1],
     [-2, 1],[-2, -1],
     [1, 2],[1, -2],
     [-1, 2],[-1, -2]]
  end

end

class King < SteppingPiece
  attr_accessor :has_moved

  def initialize(pos, board, color)
    super(pos, board, color)
    @has_moved = false
  end

  def display
    color == :white ? "♔" : "♚"
  end

  private

  def deltas
    [[1, 1],[-1, -1],
     [1, -1],[-1, 1],
     [1, 0],[-1, 0],
     [0, 1],[0, -1]]
  end

end